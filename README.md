# Config

More than dotfiles.

## Updates

These configs are actively updating:

- 012-vscode
- 014-nvim
- 028-nushell

These configs get updates not very often:

- 020-wezterm
- 026-starship

These configs get updates around a year or less only for upstream breaking changes:

- 000-fonts
- 018-hyprland
  - When I have to use my laptop.

These configs are not going to update because not used anymore:

- 002-zsh-install
  - Distro-provided installation is better.
- 003-powerline-add
- 004-windows-terminal-msys2
- 005-airline
  - Using neovim instead.
- 007-msys2
  - Using nushell instead.
- 009-qt-creator
- 011-powerlevel10k
  - Using starship instead.
- 015-oh-my-posh
  - Using starship instead.
  - May come back in the future, wezterm + starship not works well on Windows.
- 016-i3wm
  - Use sway or hyprland.
- 017-xfce
  - xfce is perfect but, no more xfce for myself.
- 021-intellij
  - vscode > jetbrains, sadly.
- 024-komorebi
  - Without tiling window manager is fine.
- 025-power-toys
  - Binary files should never exists.
- 027-sway
  - I have to use hyprland. **No more nvidia next time I setup my pc.**
- 029-tmux
  - May come back in the future when I leave wezterm.

## Sync repo config to app

To sync configs in this repo with local target directories, use symbol links.

On linux:

```bash
ln -s "/path/to/the/project/014-nvim/init.lua" "$HOME/.config/nvim/init.lua"
```

On windows:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim\init.lua" -Target "\path\to\the\project\014-nvim\init.lua"
```

Each time the repo is updated, app config is automatically synced to the latest version.

### Customized config

To set different values on locally customized configs, use environment variables.

These variables should be set in shell so apps can use them.

For example, to setup nvim colorscheme in nushell where you want different colorschemes on each machine:

1. Setup the env in shell.
  - Config the custom env in `$nu.default-config-dir/custom/custom_env.nu`:

   ```nu
   export def define_custom_env [] {
       {
           "NVIM_CUSTOM_COLORSCHEME": "catppuccin-mocha"
           "WEZTERM_CONFIG_PATH": "D:/Program/WezTerm/wezterm.lua"
       }
   }
   ```

  - When nushell starts, these environment variables are loaded in `028-nushell/env.nu`.
2. Use env in nvim.
  - In `014-nvim/post.lua`, it loads the env and setup colorscheme.

   ```lua
   local colorscheme = os.getenv('NVIM_CUSTOM_COLORSCHEME')
   if (colorscheme) then
   	vim.cmd('colorscheme ' .. colorscheme)
   end
   ```

These custom envs are **excluded** from this git repo as they have differs on different machines for customizing.
