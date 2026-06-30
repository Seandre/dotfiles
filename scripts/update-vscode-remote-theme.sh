#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
opencode_config_dir=${OPENCODE_CONFIG_DIR:-"$HOME/.config/opencode"}
opencode_themes_dir="$opencode_config_dir/themes"
install_tmux=false

usage() {
  cat <<EOF
Usage: scripts/update-vscode-remote-theme.sh [--tmux]

Run this inside the Linux environment where opencode runs. For a Windows VS Code
Remote/Dev Container setup, that means the shell inside the container.

By default this copies only the OpenCode theme files:

  ~/.config/opencode/tui.json
  ~/.config/opencode/themes/vscode-high-contrast.json

Pass --tmux to also copy tmux/remote.tmux.conf to ~/.tmux.conf and reload tmux
when a tmux server is running.

VS Code font, theme, and terminal color settings live on the Windows machine
running VS Code, not inside the SSH host or dev container.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --tmux)
      install_tmux=true
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
  fi
}

copy_file() {
  source=$1
  target=$2

  mkdir -p "$(dirname -- "$target")"

  if [ -L "$target" ]; then
    backup_if_exists "$target"
    cp "$source" "$target"
    printf "copy: %s -> %s\n" "$source" "$target"
    return
  fi

  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    printf "ok: %s already current\n" "$target"
    return
  fi

  backup_if_exists "$target"
  cp "$source" "$target"
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
    for (const file of process.argv.slice(1)) {
      JSON.parse(fs.readFileSync(file, "utf8"));
      console.log("ok: valid JSON " + file);
    }
  ' "$repo_dir/opencode/tui.json" "$repo_dir/opencode/themes/vscode-high-contrast.json"
}

install_opencode_theme() {
  ensure_real_dir "$opencode_config_dir"
  ensure_real_dir "$opencode_themes_dir"

  copy_file "$repo_dir/opencode/tui.json" "$opencode_config_dir/tui.json"
  copy_file "$repo_dir/opencode/themes/vscode-high-contrast.json" "$opencode_themes_dir/vscode-high-contrast.json"
}

install_tmux_config() {
  copy_file "$repo_dir/tmux/remote.tmux.conf" "$HOME/.tmux.conf"

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

validate_json
install_opencode_theme

if [ "$install_tmux" = true ]; then
  install_tmux_config
else
  printf "skip: tmux config unchanged; pass --tmux to update ~/.tmux.conf\n"
fi

if [ -z "${COLORTERM:-}" ]; then
  printf "note: COLORTERM is empty; set COLORTERM=truecolor in the container shell profile if colors look downgraded\n"
fi

printf "done: restart opencode inside tmux to load the updated theme\n"
