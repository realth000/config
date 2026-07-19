# nvim

Cross-platform configs for neovim.

Tested on windows and linux, likely works on macos.

## Requirements

- `nvim >= 0.12`
- (Optional) [nushell](https://www.nushell.sh/).

## Quick start

Make symbol links from `init.lua`, `lua` and `after` to the same name file or directory in nvim config dir.

### Linux

For linux:

- Config dir: `$HOME/.config/nvim`.
- Plugins and resources: `$HOME/.local/shared/nvim`.

Run in nushell in the current directory:

```nushell
ln -s $"($env.PWD)/init.lua" $"($env.HOME)/.config/nvim/init.lua"
ln -s $"($env.PWD)/lua" $"($env.HOME)/.config/nvim/lua"
ln -s $"($env.PWD)/after" $"($env.HOME)/.config/nvim/after"
```

### Windows

For windows:

- Config: `$HOME/AppData/Local/nvim`.
- Plugins and resources: `$HOME/AppData/Local/nvim-data`.

Run in powershell in the current directory:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\nvim\init.lua" -Target "$($PWD.ProviderPath)\init.lua"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\nvim\lua" -Target "$($PWD.ProviderPath)\lua"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\nvim\after" -Target "$($PWD.ProviderPath)\after"
```

## Plugins

- Package manager:
  - [folke/lazy.nvim](https://github.com/folke/lazy.nvim) for lazy loading.
- LSP:
  - [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for setup lsp configs.
  - [williamboman/mason.nvim](https://github.com/mason-org/mason.nvim) for managing language server.
- Highlighting:
  - Built-in [tree-sitter](https://neovim.io/doc/user/treesitter/#treesitter) for great semantics based syntax highlighting.
  - [romus204/tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim) for managing parsers and highlighters.
- Auto completion:
  - [saghen/blink.cmp](https://github.com/saghen/blink.cmp) for most completion based on lsp or text.
  - [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) for pairing characters.
- Filter:
  - [nvim-telescope//telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for searching strings and files.
- File manager:
  - [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) for sidebar style file explorer.
- UI styling:
  - [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) for bottom info line.
  - [folke/noice.nvim](https://github.com/folke/noice.nvim) for more floating windows as inputs.
  - [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for inline and file git blames.
  - [HiPhish/rainbow-delimiters.nvim](https://github.com/hiphish/rainbow-delimiters.nvim) for colorful brackets.
  - [RRethy/vim-illuminate](https://github.com/rrethy/vim-illuminate) for highlighting words at current cursor.
- Shell integration:
  - [numToStr/FTerm.nvim](https://github.com/numtostr/fterm.nvim) for terminal integration.
    - Use [nushell](https://www.nushell.sh/) as the default shell.
- Themes:
  - [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)
  - [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
  - [projekt0n/github-nvim-theme](https://github.com/projekt0n/github-nvim-theme)
  - [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
  - [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
  - [wcatppuccin/nvim](https://github.com/wcatppuccin/nvim)
  - [hardhackerlabs/theme-vim](https://github.com/hardhackerlabs/theme-vim)
  - [loctvl842/monokai-pro.nvim](https://github.com/loctvl842/monokai-pro.nvim)
  - [kepano/flexoki-neovim](https://github.com/kepano/flexoki-neovim)
  - [bluz71/vim-nightfly-colors](https://github.com/bluz71/vim-nightfly-colors)
  - [AlexvZyl/nordic.nvim](https://github.com/AlexvZyl/nordic.nvim)
  - [luisiacc/gruvbox-baby](https://github.com/luisiacc/gruvbox-baby)
  - [rose-pine/neovim](https://github.com/rose-pine/neovim)
  - [bluz71/vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors)
  - [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
  - [sho-87/kanagawa-paper.nvim](https://github.com/sho-87/kanagawa-paper.nvim)
  - [bgwdotdev/gleam-theme-nvim](https://github.com/bgwdotdev/gleam-theme-nvim)
  - [alexmozaidze/palenight.nvim](https://github.com/alexmozaidze/palenight.nvim)
  - [wtfox/jellybeans.nvim](https://github.com/wtfox/jellybeans.nvim)
  - [metalelf0/kintsugi-nvim](https://github.com/metalelf0/kintsugi-nvim)

## Advanced features

A lot of configs and behaviors are set via environment variables.

Most features described in this section depends on environment variables.

For more info about using envs in config, see `Customizing configs` section in [repo readme](../README.md).

### Shell integration

Uses nushell to reach consist cross-platform shell experience.

By default [nushell](https://www.nushell.sh/) is the shell we use when running command and invoking floating terminal windows. It is powerful, some kind bashlike and cross-platform.

- To tell enable nushell integration, set `NVIM_CUSTOM_USE_NUSHELL` to `true` and place nu in path where it becomes a global executable.
- To disable nushell integration, set `cmd` in [fterm config](./after/plugin/fterm.lua) to another value or comment it.
  - Disabing nushell makes some script based features unavailable.

### Customizing colorscheme

- Set the current colorscheme name in `NVIM_CUSTOM_COLORSCHEME` in env.
- Enable dark background via setting `NVIM_CUSTOM_USE_DARK_MODE` in env.

Check [post.lua](./after/post.lua) for details.

### Colorscheme update

> This feature requires nushell.

When `colorscheme` command is called to set the theme, these configs are also updated:

- nvim theme in config.
- wezterm theme in config.
- alacritty theme in config.

if enabled in env, and the related program and nushell are available.

To enable these sync actions, set `NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME`, `NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME` and `NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME` to `true` in env.

Check [post.lua](./after/post.lua) for details.

### Transparent background

To enable transparent background in colorscheme, if the theme plugin supports, set `NVIM_CUSTOM_TRANSPARENT_BACKGROUND` to `true` in env.

Check [pre.lua](./after/pre.lua) for details.

### Paired operation on pipe sign

For `|`, paired operations are useful like what we have for `(`:

- `di|` deletes all text inside the current `|` pair.
- `da|` deletes all text inside the current `|` pair and surrounded `|`.
- `ci|` deletes all text inside the current `|` pair and switch to insert mode.
- `ca|` deletes all text inside the current `|` pair and surrounded `|`, then switch to insert mode.

This is helpful for languages using paired `|` syntax, like bash and rust.

Check [basic.lua](./after/basic.lua) for details.
