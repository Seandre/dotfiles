# Dotfiles

Personal Neovim, tmux, Kitty, VS Code, and OpenCode configuration backup.

This repo is organized around two environments:

- `macbook-kitty`: local macOS setup using Kitty, full tmux plugins, local VS Code settings, Neovim, and OpenCode.
- `linux-vscode-remote`: remote Linux setup used through VS Code Remote SSH, with portable tmux, Neovim, and OpenCode terminal config only.

## Layout

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf` on remote Linux hosts
- `kitty/` -> `~/.config/kitty`
- `vscode/settings.json` -> VS Code user `settings.json`
- `vscode/settings.custom-high-contrast.json` -> saved custom VS Code high contrast overrides
- `opencode/` -> `~/.config/opencode` theme files

## Setup

Use the setup script for the machine you are on. Both scripts back up existing files/directories to `*.bak-YYYYmmddHHMMSS` before replacing them.

On the MacBook using Kitty:

```sh
~/dotfiles/scripts/setup-macbook.sh
```

This links:

- `nvim/` -> `~/.config/nvim`
- `tmux/tmux.conf` -> `~/.tmux.conf`
- `kitty/` -> `~/.config/kitty`
- `vscode/settings.json` -> macOS VS Code user `settings.json`
- `opencode/tui.json` and `opencode/themes/` -> `~/.config/opencode`

The macOS tmux config enables mouse support so pane clicks, scrolling, resizing, and drag selection stay pane-aware. Copy-mode selections copy to the macOS clipboard through `pbcopy`.

On a remote Linux host used through VS Code Remote SSH:

```sh
~/dotfiles/scripts/setup-vscode-remote.sh
```

This links:

- `nvim/` -> `~/.config/nvim`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf`
- `opencode/tui.json` and `opencode/themes/` -> `~/.config/opencode`

Do not install the Kitty config on the Linux host unless Kitty is running there directly. Do not install the VS Code settings on the Linux host for Remote SSH; the integrated terminal is rendered by the local VS Code app.

For dev containers or other remote environments where symlinks back to the dotfiles checkout are not desirable, copy the OpenCode theme files instead:

```sh
~/dotfiles/scripts/setup-vscode-remote.sh --copy-opencode
```

This still links Neovim and tmux, but copies:

- `opencode/tui.json` -> `~/.config/opencode/tui.json`
- `opencode/themes/vscode-high-contrast.json` -> `~/.config/opencode/themes/vscode-high-contrast.json`

To revert OpenCode to its built-in default TUI theme inside the Linux environment:

```sh
~/dotfiles/scripts/setup-vscode-remote.sh --revert-opencode-theme
```

This backs up and removes the OpenCode TUI theme selector and the custom `vscode-high-contrast` theme file from `~/.config/opencode`.

The remote tmux config avoids TPM plugins, macOS-only clipboard commands, local paths, battery/status helpers, and Nerd Font glyphs. Clipboard integration uses tmux's native `set-clipboard on`, which works with OSC52 when the terminal and SSH path allow it.

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
~/dotfiles/scripts/setup-vscode-remote.sh
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

The active VS Code settings keep `Default High Contrast` enabled without custom color overrides. This lets the local MacBook VS Code window show the built-in high contrast defaults while testing the matching OpenCode theme on a remote Linux host.

The integrated terminal font is not overridden; VS Code uses its default terminal font settings. Terminal colors are provided by VS Code's built-in `Default High Contrast` theme, with `terminal.integrated.minimumContrastRatio` set to `1` so terminal apps such as OpenCode can render the exact truecolor values from their themes.

VS Code's integrated terminal does not natively support Kitty's `background_opacity 0.6`, `background_blur 15`, or dynamic background opacity, so those settings are intentionally not represented here.

The previous custom color override version is saved at `vscode/settings.custom-high-contrast.json`.

## OpenCode Theme

The OpenCode TUI theme is selected with `opencode/tui.json` and defined in `opencode/themes/vscode-high-contrast.json`. OpenCode does not consume VS Code theme keys directly; it has its own fixed `theme.json` slots for base UI, diff, markdown, and syntax colors. The theme maps those slots to VS Code's built-in Dark High Contrast defaults from `hc_black.json`: pure black background, white foreground and borders, green selection as the primary UI accent, and the default High Contrast token colors for comments, strings, numbers, keywords, functions, variables, types, operators, punctuation, headings, and diffs.
