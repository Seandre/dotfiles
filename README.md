# Dotfiles

Personal Neovim and tmux configuration backup.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`

## Restore

Back up any existing config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
```

Symlink these configs:

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
```
