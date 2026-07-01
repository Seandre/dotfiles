#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
opencode_config_dir=${OPENCODE_CONFIG_DIR:-"$HOME/.config/opencode"}
opencode_themes_dir="$opencode_config_dir/themes"
custom_theme_name=${OPENCODE_THEME_NAME:-"vscode-high-contrast"}
vscode_server_dir=${VSCODE_AGENT_FOLDER:-"$HOME/.vscode-server"}
vscode_machine_settings=${VSCODE_SETTINGS_PATH:-"$vscode_server_dir/data/Machine/settings.json"}
tmux_copy_command="$HOME/.local/bin/tmux-copy-to-clipboard"
copy_all=false
copy_opencode=false
revert_opencode=false

usage() {
  cat <<EOF
Usage: scripts/setup-vscode-remote.sh [--copy] [--copy-opencode] [--revert-opencode-theme]

Install the Linux profile used through VS Code Remote SSH:
  nvim, portable tmux, tmux clipboard helper, VS Code Server machine settings,
  and OpenCode terminal theme files.

Options:
  --copy                    Copy all installed config instead of symlinking.
                            Useful inside dev containers or ephemeral workspaces.
  --copy-opencode           Copy OpenCode theme files instead of symlinking them.
                            Kept for older workflows; --copy is preferred for containers.
  --revert-opencode-theme   Back up and remove the custom OpenCode theme selector
                            so OpenCode uses its built-in default TUI theme.

Environment:
  VSCODE_AGENT_FOLDER       VS Code Server root. Defaults to ~/.vscode-server.
  VSCODE_SETTINGS_PATH      Exact VS Code settings target path, if the container
                            uses a nonstandard server/settings layout.
  OPENCODE_CONFIG_DIR       OpenCode config root. Defaults to ~/.config/opencode.

Existing files/directories are moved to *.bak-YYYYmmddHHMMSS first.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --copy)
      copy_all=true
      copy_opencode=true
      ;;
    --copy-opencode)
      copy_opencode=true
      ;;
    --revert-opencode-theme)
      revert_opencode=true
      ;;
    -h|--help|help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

backup_path() {
  path=$1
  printf "%s.bak-%s" "$path" "$(date +%Y%m%d%H%M%S)"
}

backup_if_exists() {
  path=$1

  if [ -e "$path" ] || [ -L "$path" ]; then
    backup=$(backup_path "$path")
    mv "$path" "$backup"
    printf "backup: %s -> %s\n" "$path" "$backup"
  else
    printf "ok: %s not present\n" "$path"
  fi
}

link_path() {
  source=$1
  target=$2

  mkdir -p "$(dirname -- "$target")"

  if [ -L "$target" ]; then
    current=$(readlink "$target")
    if [ "$current" = "$source" ]; then
      printf "ok: %s -> %s\n" "$target" "$source"
      return
    fi
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_if_exists "$target"
  fi

  ln -s "$source" "$target"
  printf "link: %s -> %s\n" "$target" "$source"
}

copy_file() {
  source=$1
  target=$2

  mkdir -p "$(dirname -- "$target")"

  if [ -f "$target" ] && [ ! -L "$target" ] && cmp -s "$source" "$target"; then
    printf "ok: %s already current\n" "$target"
    return
  fi

  backup_if_exists "$target"
  cp "$source" "$target"
  printf "copy: %s -> %s\n" "$source" "$target"
}

copy_dir() {
  source=$1
  target=$2

  mkdir -p "$(dirname -- "$target")"
  backup_if_exists "$target"
  cp -R "$source" "$target"
  printf "copy: %s -> %s\n" "$source" "$target"
}

ensure_real_dir() {
  path=$1

  if [ -L "$path" ]; then
    backup_if_exists "$path"
  fi

  mkdir -p "$path"
}

validate_json() {
  if ! command -v node >/dev/null 2>&1; then
    printf "skip: node not found, JSON validation skipped\n"
    return
  fi

  node -e '
    const fs = require("fs");
    const path = require("path");
    for (const file of process.argv.slice(1)) {
      JSON.parse(fs.readFileSync(file, "utf8"));
      console.log("ok: valid JSON " + file);
    }
    const repo = process.env.REPO_DIR;
    const tui = JSON.parse(fs.readFileSync(path.join(repo, "opencode/tui.json"), "utf8"));
    const themeFile = path.join(repo, "opencode/themes", tui.theme + ".json");
    if (!fs.existsSync(themeFile)) {
      throw new Error("OpenCode theme file missing: " + themeFile);
    }
    const theme = JSON.parse(fs.readFileSync(themeFile, "utf8"));
    const missing = [];
    for (const [slot, value] of Object.entries(theme.theme || {})) {
      for (const mode of ["dark", "light"]) {
        if (!value || typeof value[mode] !== "string") {
          missing.push(slot + "." + mode + ": missing");
        } else if (!theme.defs || !theme.defs[value[mode]]) {
          missing.push(slot + "." + mode + ": unresolved " + value[mode]);
        }
      }
    }
    if (missing.length > 0) {
      throw new Error("OpenCode theme references invalid colors:\n" + missing.join("\n"));
    }
    for (const [slot, value] of Object.entries(theme.theme || {})) {
      if (/^background|Bg$/i.test(slot) && (value.dark !== "black" || value.light !== "black")) {
        throw new Error("OpenCode background slot is not black: " + slot);
      }
    }
    console.log("ok: OpenCode theme selected " + tui.theme);
  ' \
    "$repo_dir/vscode/settings.json" \
    "$repo_dir/opencode/tui.json" \
    "$repo_dir/opencode/themes/vscode-high-contrast.json"
}

install_opencode_links() {
  mkdir -p "$opencode_config_dir"
  link_path "$repo_dir/opencode/tui.json" "$opencode_config_dir/tui.json"
  link_path "$repo_dir/opencode/themes" "$opencode_themes_dir"
}

install_opencode_copies() {
  ensure_real_dir "$opencode_config_dir"
  ensure_real_dir "$opencode_themes_dir"
  copy_file "$repo_dir/opencode/tui.json" "$opencode_config_dir/tui.json"
  copy_file "$repo_dir/opencode/themes/vscode-high-contrast.json" "$opencode_themes_dir/vscode-high-contrast.json"
}

revert_opencode_theme() {
  backup_if_exists "$opencode_config_dir/tui.json"

  if [ -L "$opencode_themes_dir" ]; then
    backup_if_exists "$opencode_themes_dir"
  else
    backup_if_exists "$opencode_themes_dir/$custom_theme_name.json"
  fi

  printf "done: restart opencode to use its built-in default TUI theme\n"
}

reload_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    printf "skip: tmux not found, reload skipped\n"
    return
  fi

  if tmux ls >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf"
    printf "reload: tmux sourced %s\n" "$HOME/.tmux.conf"
  else
    printf "skip: no running tmux server to reload\n"
  fi
}

if [ "$revert_opencode" = true ]; then
  revert_opencode_theme
  exit 0
fi

REPO_DIR=$repo_dir
export REPO_DIR
validate_json

if [ "$copy_all" = true ]; then
  copy_dir "$repo_dir/nvim" "$HOME/.config/nvim"
  copy_file "$repo_dir/tmux/remote.tmux.conf" "$HOME/.tmux.conf"
  copy_file "$repo_dir/tmux/copy-to-clipboard.sh" "$tmux_copy_command"
  copy_file "$repo_dir/vscode/settings.json" "$vscode_machine_settings"
else
  link_path "$repo_dir/nvim" "$HOME/.config/nvim"
  link_path "$repo_dir/tmux/remote.tmux.conf" "$HOME/.tmux.conf"
  link_path "$repo_dir/tmux/copy-to-clipboard.sh" "$tmux_copy_command"
  link_path "$repo_dir/vscode/settings.json" "$vscode_machine_settings"
fi
chmod +x "$tmux_copy_command"

if [ "$copy_opencode" = true ]; then
  install_opencode_copies
else
  install_opencode_links
fi

reload_tmux

if [ -z "${COLORTERM:-}" ]; then
  printf "note: COLORTERM is empty; set COLORTERM=truecolor in the remote shell profile if colors look downgraded\n"
fi

printf "done: vscode remote profile installed\n"
