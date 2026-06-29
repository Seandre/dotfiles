# Dotfiles

Personal Neovim, tmux, Kitty, and VS Code configuration backup.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf` on remote Linux hosts
- `kitty/` -> `~/.config/kitty`
- `vscode/settings.json` -> VS Code user `settings.json`

## Restore

Back up any existing config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
mv ~/.config/kitty ~/.config/kitty.bak
mv "$HOME/Library/Application Support/Code/User/settings.json" "$HOME/Library/Application Support/Code/User/settings.json.bak"
```

Symlink these configs:

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
```

For remote Linux hosts accessed through VS Code Remote SSH, use the portable tmux config instead:

```sh
ln -s ~/dotfiles/tmux/remote.tmux.conf ~/.tmux.conf
```

The remote config avoids TPM plugins, macOS-only clipboard commands, local paths, battery/status helpers, and Nerd Font glyphs. Clipboard integration uses tmux's native `set-clipboard on`, which works with OSC52 when the terminal and SSH path allow it.

## VS Code Terminal

The VS Code settings keep `Default High Contrast` enabled and scope terminal color overrides to that theme. The integrated terminal font is set to Kitty's `SF Mono` at size `12`.

Most ANSI accent colors are copied from `kitty/theme.conf`, but the default foreground, cursor, selection, black, and white slots are neutralized to better match the live Kitty configuration, where `kitty/theme.conf` is not currently included. The terminal background is pure black to match VS Code's high contrast workbench background.

VS Code's integrated terminal does not natively support Kitty's `background_opacity 0.6`, `background_blur 15`, or dynamic background opacity, so those settings are intentionally not represented here. The `terminal.integrated.minimumContrastRatio` value is set to `1` so VS Code does not remap the tracked Gruvbox ANSI colors under the high contrast theme.
