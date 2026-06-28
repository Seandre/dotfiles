# Dotfiles

Personal Neovim, tmux, and Kitty configuration backup.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
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
