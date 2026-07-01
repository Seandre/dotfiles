# Dotfiles

Personal Neovim, tmux, Kitty, VS Code, and OpenCode configuration backup.

This repo is organized around two environments:

- `macbook-kitty`: local macOS setup using Kitty, full tmux plugins, local VS Code settings, Neovim, and OpenCode.
- `linux-vscode-remote`: remote Linux setup used through VS Code Remote SSH, with portable tmux, Neovim, VS Code Server settings, and OpenCode terminal config.

## Layout

- `nvim/` -> `~/.config/nvim`
- `vim/remote.vimrc` -> `~/.vimrc` on remote Linux hosts
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
- `vim/remote.vimrc` -> `~/.vimrc`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf`
- `tmux/copy-to-clipboard.sh` -> `~/.local/bin/tmux-copy-to-clipboard`
- `vscode/settings.json` -> VS Code Server machine `settings.json`
- `opencode/tui.json` and `opencode/themes/` -> `~/.config/opencode`

Do not install the Kitty config on the Linux host unless Kitty is running there directly. The remote setup script installs the same VS Code settings into the VS Code Server machine settings path, using `VSCODE_AGENT_FOLDER` when available and otherwise `~/.vscode-server/data/Machine/settings.json`.

For dev containers or other remote environments where symlinks back to the dotfiles checkout are not desirable, copy the installed config instead:

```sh
~/dotfiles/scripts/setup-vscode-remote.sh --copy
```

This copies:

- `nvim/` -> `~/.config/nvim`
- `vim/remote.vimrc` -> `~/.vimrc`
- `tmux/remote.tmux.conf` -> `~/.tmux.conf`
- `tmux/copy-to-clipboard.sh` -> `~/.local/bin/tmux-copy-to-clipboard`
- `vscode/settings.json` -> VS Code Server machine `settings.json`
- `opencode/tui.json` -> `~/.config/opencode/tui.json`
- `opencode/themes/vscode-high-contrast.json` -> `~/.config/opencode/themes/vscode-high-contrast.json`

`--copy-opencode` is still available for older workflows that only need OpenCode copied while keeping Neovim, tmux, and VS Code settings symlinked.

For containerized environments, prefer `--copy`: it applies the VS Code theme settings, the portable tmux theme/config, and the OpenCode TUI theme as real files under the container user's home/config paths.

If a container uses a nonstandard VS Code settings path, set `VSCODE_SETTINGS_PATH` to the exact target before running the script.

To revert OpenCode to its built-in default TUI theme inside the Linux environment:

```sh
~/dotfiles/scripts/setup-vscode-remote.sh --revert-opencode-theme
```

This backs up and removes the OpenCode TUI theme selector and the custom `vscode-high-contrast` theme file from `~/.config/opencode`.

The remote Vim config keeps plain Vim legible in VS Code SSH terminals and tmux by forcing a dark background, white base text, visible Visual/Search highlights, and explicit Gruvbox-style syntax and diff colors.

The remote tmux config avoids TPM plugins, local paths, battery/status helpers, and Nerd Font glyphs. It enables mouse support for pane clicks, scrolling, resizing, and drag selection. Copy-mode `y`, Enter, and mouse drag copy through `~/.local/bin/tmux-copy-to-clipboard`, which uses `pbcopy`, `wl-copy`, `xclip`, `xsel`, WSL `clip.exe`, or `powershell.exe` when available. It also keeps tmux's native `set-clipboard on` enabled for terminals that support OSC52.

## Remote SSH Linux Setup

The VS Code terminal colors are installed by both setup scripts. On the Mac that runs VS Code, `scripts/setup-macbook.sh` links `vscode/settings.json` into the local user settings path. On a Remote SSH host, `scripts/setup-vscode-remote.sh` links the same file into the VS Code Server machine settings path. Do not symlink the Kitty config on the Linux host unless that host also runs Kitty directly.

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
echo "$TERM"             # xterm-256color outside tmux, screen-256color inside tmux
tmux -V
opencode --version
```

Validation flow from VS Code Remote SSH:

```sh
# In a VS Code Remote SSH integrated terminal
tmux new -A -s main
opencode
```

The terminal background and base text color come from the shared VS Code settings installed by the setup scripts. The tmux status, pane borders, copy mode, and OpenCode UI colors come from the remote dotfiles.

## VS Code Theme

The active VS Code settings use `Dark Modern` as a stable built-in host theme, then override the visible UI, syntax, and terminal colors with the Gruvbox dark hard palette from `ellisonleao/gruvbox.nvim`. All VS Code background slots are forced to pure black, and normal editor/UI text is forced to pure white to match the Neovim Gruvbox override. This keeps the theme symlinkable as a normal VS Code `settings.json` instead of requiring a packaged VS Code extension.

The integrated terminal font is not overridden; VS Code uses its default terminal font settings. Terminal colors are provided by the Gruvbox ANSI mapping in `vscode/settings.json`, with `terminal.integrated.minimumContrastRatio` set to `1` so terminal apps such as OpenCode can render exact theme colors without VS Code contrast adjustment.

VS Code's integrated terminal does not natively support Kitty's `background_opacity 0.6`, `background_blur 15`, or dynamic background opacity, so those settings are intentionally not represented here.

The previous custom high contrast override version is saved at `vscode/settings.custom-high-contrast.json`.

## OpenCode Theme

The OpenCode TUI theme is selected with `opencode/tui.json` and defined in `opencode/themes/vscode-high-contrast.json`. OpenCode does not consume VS Code theme keys directly; it has its own fixed `theme.json` slots for base UI, diff, markdown, and syntax colors. The theme maps every known slot from the installed OpenCode TUI theme surface to the same local VS Code color intent: pure black backgrounds, pure white base text, Gruvbox dark hard accents for syntax and diagnostics, and muted Gruvbox borders. The setup scripts validate that the selected OpenCode theme exists, every slot resolves to a defined color, and all background slots remain black.
