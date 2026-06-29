# Dotfiles

Personal Neovim, tmux, and Kitty configuration backup.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf` on remote Linux hosts
- `kitty/` -> `~/.config/kitty`

## Restore

Back up any existing config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
mv ~/.config/kitty ~/.config/kitty.bak
```

Symlink these configs:

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/kitty ~/.config/kitty
```

For remote Linux hosts accessed through VS Code Remote SSH, use the portable tmux config instead:

```sh
ln -s ~/dotfiles/tmux/remote.tmux.conf ~/.tmux.conf
```

The remote config avoids TPM plugins, macOS-only clipboard commands, local paths, battery/status helpers, and Nerd Font glyphs. Clipboard integration uses tmux's native `set-clipboard on`, which works with OSC52 when the terminal and SSH path allow it.
