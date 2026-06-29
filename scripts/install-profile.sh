#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
profile=${1:-}

usage() {
  cat <<EOF
Usage: scripts/install-profile.sh <profile>

Profiles:
  macbook-kitty         MacBook using Kitty locally
  linux-vscode-remote  Linux host accessed through VS Code Remote SSH
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

install_common_terminal() {
  link_path "$repo_dir/nvim" "$HOME/.config/nvim"
  mkdir -p "$HOME/.config/opencode"
  link_path "$repo_dir/opencode/tui.json" "$HOME/.config/opencode/tui.json"
  link_path "$repo_dir/opencode/themes" "$HOME/.config/opencode/themes"
}

install_macbook_kitty() {
  install_common_terminal
  link_path "$repo_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
  link_path "$repo_dir/kitty" "$HOME/.config/kitty"
  link_path "$repo_dir/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
}

install_linux_vscode_remote() {
  install_common_terminal
  link_path "$repo_dir/tmux/remote.tmux.conf" "$HOME/.tmux.conf"
}

case "$profile" in
  macbook-kitty)
    install_macbook_kitty
    ;;
  linux-vscode-remote)
    install_linux_vscode_remote
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
