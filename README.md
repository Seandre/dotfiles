# Dotfiles

Personal Neovim, tmux, Kitty, VS Code, and OpenCode configuration backup.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf` on remote Linux hosts
- `kitty/` -> `~/.config/kitty`
- `vscode/settings.json` -> VS Code user `settings.json`
- `opencode/` -> `~/.config/opencode` theme files

## Restore

Back up any existing config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
mv ~/.config/kitty ~/.config/kitty.bak
mv "$HOME/Library/Application Support/Code/User/settings.json" "$HOME/Library/Application Support/Code/User/settings.json.bak"
mv ~/.config/opencode/tui.json ~/.config/opencode/tui.json.bak
```

Symlink these configs:

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
mkdir -p ~/.config/opencode
ln -s ~/dotfiles/opencode/tui.json ~/.config/opencode/tui.json
ln -s ~/dotfiles/opencode/themes ~/.config/opencode/themes
```

For remote Linux hosts accessed through VS Code Remote SSH, use the portable tmux config instead:

```sh
ln -s ~/dotfiles/tmux/remote.tmux.conf ~/.tmux.conf
```

The remote config avoids TPM plugins, macOS-only clipboard commands, local paths, battery/status helpers, and Nerd Font glyphs. Clipboard integration uses tmux's native `set-clipboard on`, which works with OSC52 when the terminal and SSH path allow it.

## Remote SSH Linux Setup

The VS Code terminal colors are local user settings. Apply `vscode/settings.json` on the Mac that runs VS Code; Remote SSH terminals inherit those colors because they render inside the local VS Code window. Do not symlink the VS Code or Kitty configs on the Linux host unless that host also runs those apps directly.

On the remote Linux host, install the terminal-side tools and clone these dotfiles:

```sh
# Debian/Ubuntu example
sudo apt update
sudo apt install -y git tmux curl

# Install OpenCode if you plan to run it on the remote host.
# Requires a working Node/npm install.
npm install -g opencode-ai

git clone git@github.com:Seandre/dotfiles.git ~/dotfiles
```

Use the portable tmux config on the remote host:

```sh
mv ~/.tmux.conf ~/.tmux.conf.bak 2>/dev/null || true
ln -s ~/dotfiles/tmux/remote.tmux.conf ~/.tmux.conf
```

Install the OpenCode theme on the remote host if you run `opencode` there:

```sh
mkdir -p ~/.config/opencode
mv ~/.config/opencode/tui.json ~/.config/opencode/tui.json.bak 2>/dev/null || true
mv ~/.config/opencode/themes ~/.config/opencode/themes.bak 2>/dev/null || true
ln -s ~/dotfiles/opencode/tui.json ~/.config/opencode/tui.json
ln -s ~/dotfiles/opencode/themes ~/.config/opencode/themes
```

Make sure truecolor is available in the remote shell. Add this to the remote shell profile if `echo $COLORTERM` is empty:

```sh
export COLORTERM=truecolor
```

Expected terminal values:

```sh
echo "$COLORTERM"        # truecolor or 24bit
echo "$TERM"             # xterm-256color outside tmux, tmux-256color inside tmux
tmux -V
opencode --version
```

Validation flow from VS Code Remote SSH:

```sh
# In a VS Code Remote SSH integrated terminal
tmux new -A -s main
opencode
```

The terminal background and base text color come from local VS Code. The tmux status, pane borders, copy mode, and OpenCode UI colors come from the remote dotfiles.

## VS Code Theme

The VS Code settings keep `Default High Contrast` enabled and scope all color overrides to that theme. This avoids maintaining a custom VS Code extension while still making the editor, side bar, tabs, status bar, panel, inputs, lists, diagnostics, diffs, token colors, and integrated terminal share a high-contrast palette tuned for readability: black surfaces, near-white text, lighter muted text, clear blue selections, and cool blue/cyan accents.

The integrated terminal font is set to Kitty's `SF Mono` at size `12`. Terminal ANSI colors keep the same general families as the Kitty palette, but low-contrast colors are brightened for readability on pure black. The terminal and editor background are pure black to match VS Code's high contrast workbench background.

VS Code's integrated terminal does not natively support Kitty's `background_opacity 0.6`, `background_blur 15`, or dynamic background opacity, so those settings are intentionally not represented here. The `terminal.integrated.minimumContrastRatio` value is set to `1` so VS Code does not remap the tracked Gruvbox ANSI colors under the high contrast theme.

A packaged custom VS Code theme is also possible, but it requires a theme extension or VSIX install. For these dotfiles, `workbench.colorCustomizations` and `editor.tokenColorCustomizations` are the lower-maintenance path.

## OpenCode Theme

The OpenCode TUI theme is selected with `opencode/tui.json` and defined in `opencode/themes/vscode-high-contrast.json`. It mirrors the VS Code terminal setup: pure black background, near-white text, neutral panels and borders, and Gruvbox-derived accent colors.
