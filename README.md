# Config

More than dotfiles.

## Updates

Configs actively updating:

- 012-vscode
- 014-nvim
- 028-nushell

Configs get updates not very often:

- 018-hyprland
- 020-wezterm
- 026-starship
- 032-zellij
- 033-alacritty

Configs get updates for upstream breaking changes:

- 000-fonts

Configs no longer in use:

- 002-zsh-install
- 003-powerline-add
- 004-windows-terminal-msys2
- 005-airline
- 007-msys2
- 009-qt-creator
- 011-powerlevel10k
- 015-oh-my-posh
- 016-i3wm
- 017-xfce
- 021-intellij
- 024-komorebi
- 025-power-toys
- 027-sway
- 029-tmux

## Sync config from repo to app

Use symbol links to sync configs from repo to app config directories.

On linux:

```bash
ln -s "/path/to/the/repo/014-nvim/init.lua" "$HOME/.config/nvim/init.lua"
```

On windows:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\init.lua" -Target "\path\to\the\repo\014-nvim\init.lua"
```

## Customizing configs

To use different config values on each machine, use environment variables.

> These envs should be excluded from this repo.

For example, to setup nvim colorscheme in nushell where you want different colorschemes on each machine:

1. Setup env in shell.
  - Config the custom env in `$nu.default-config-dir/custom/custom_env.nu`:

   ```nu
   export def define_custom_env [] {
       {
           "NVIM_CUSTOM_COLORSCHEME": "catppuccin-mocha"
       }
   }
   ```

  - When nushell starts, `NVIM_CUSTOM_COLORSCHEME` is loaded in `028-nushell/env.nu`.
2. Use env in nvim.
  - In `014-nvim/post.lua`, checks the env and load colorscheme.

   ```lua
   local colorscheme = os.getenv('NVIM_CUSTOM_COLORSCHEME')
   if (colorscheme) then
   	vim.cmd('colorscheme ' .. colorscheme)
   end
   ```

