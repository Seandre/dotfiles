#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
opencode_config_dir=${OPENCODE_CONFIG_DIR:-"$HOME/.config/opencode"}
opencode_themes_dir="$opencode_config_dir/themes"

usage() {
  cat <<EOF
Usage: scripts/update-vscode-remote-theme.sh

Run this on a Linux host used from VS Code Remote SSH, inside the dotfiles
checkout. It updates the remote terminal-side theme files:

  ~/.tmux.conf
  ~/.config/opencode/tui.json
  ~/.config/opencode/themes/vscode-high-contrast.json

VS Code's own font and terminal color settings are local to the machine running
VS Code, not the remote host.
EOF
}

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
    for (const file of process.argv.slice(1)) {
      JSON.parse(fs.readFileSync(file, "utf8"));
      console.log("ok: valid JSON " + file);
    }
  ' "$repo_dir/opencode/tui.json" "$repo_dir/opencode/themes/vscode-high-contrast.json"
}

install_opencode_theme() {
  mkdir -p "$opencode_config_dir"
  link_path "$repo_dir/opencode/tui.json" "$opencode_config_dir/tui.json"

  if [ -L "$opencode_themes_dir" ]; then
    current=$(readlink "$opencode_themes_dir")
    if [ "$current" = "$repo_dir/opencode/themes" ]; then
      printf "ok: %s -> %s\n" "$opencode_themes_dir" "$repo_dir/opencode/themes"
      return
    fi
  fi

  mkdir -p "$opencode_themes_dir"
  link_path "$repo_dir/opencode/themes/vscode-high-contrast.json" "$opencode_themes_dir/vscode-high-contrast.json"
}

install_tmux_config() {
  link_path "$repo_dir/tmux/remote.tmux.conf" "$HOME/.tmux.conf"

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

case "${1:-}" in
  "" )
    validate_json
    install_opencode_theme
    install_tmux_config

    if [ -z "${COLORTERM:-}" ]; then
      printf "note: COLORTERM is empty; set COLORTERM=truecolor in the remote shell profile if colors look downgraded\n"
    fi

    printf "done: restart opencode inside tmux to load the updated theme\n"
    ;;
  -h|--help|help )
    usage
    ;;
  * )
    usage >&2
    exit 2
    ;;
esac
