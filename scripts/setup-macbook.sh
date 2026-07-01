#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

usage() {
  cat <<EOF
Usage: scripts/setup-macbook.sh

Install the local macOS profile:
  nvim, tmux, Kitty, VS Code user settings, and OpenCode theme files.

Existing files/directories are moved to *.bak-YYYYmmddHHMMSS first.
EOF
}

case "${1:-}" in
  "")
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

backup_path() {
  path=$1
  printf "%s.bak-%s" "$path" "$(date +%Y%m%d%H%M%S)"
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
    backup=$(backup_path "$target")
    mv "$target" "$backup"
    printf "backup: %s -> %s\n" "$target" "$backup"
  fi

  ln -s "$source" "$target"
  printf "link: %s -> %s\n" "$target" "$source"
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

REPO_DIR=$repo_dir
export REPO_DIR
validate_json

link_path "$repo_dir/nvim" "$HOME/.config/nvim"
link_path "$repo_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
link_path "$repo_dir/kitty" "$HOME/.config/kitty"
link_path "$repo_dir/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

mkdir -p "$HOME/.config/opencode"
link_path "$repo_dir/opencode/tui.json" "$HOME/.config/opencode/tui.json"
link_path "$repo_dir/opencode/themes" "$HOME/.config/opencode/themes"

printf "done: macbook profile installed\n"
