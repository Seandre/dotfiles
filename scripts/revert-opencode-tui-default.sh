#!/usr/bin/env sh
set -eu

opencode_config_dir=${OPENCODE_CONFIG_DIR:-"$HOME/.config/opencode"}
opencode_themes_dir="$opencode_config_dir/themes"
custom_theme_name=${OPENCODE_THEME_NAME:-"vscode-high-contrast"}

usage() {
  cat <<EOF
Usage: scripts/revert-opencode-tui-default.sh

Run this inside the Linux environment where opencode runs. For a Windows VS Code
Remote/Dev Container setup, that means the shell inside the container.

This reverts OpenCode's TUI to its built-in default by backing up and removing:

  ~/.config/opencode/tui.json
  ~/.config/opencode/themes/${custom_theme_name}.json

If ~/.config/opencode/themes is itself a symlink, the script backs up that
symlink instead of following it, so the dotfiles repo is not modified.
EOF
}

case "${1:-}" in
  "" )
    ;;
  -h|--help|help )
    usage
    exit 0
    ;;
  * )
    usage >&2
    exit 2
    ;;
esac

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

backup_if_exists "$opencode_config_dir/tui.json"

if [ -L "$opencode_themes_dir" ]; then
  backup_if_exists "$opencode_themes_dir"
else
  backup_if_exists "$opencode_themes_dir/$custom_theme_name.json"
fi

printf "done: restart opencode to use its built-in default TUI theme\n"
