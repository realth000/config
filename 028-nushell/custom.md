# Custom configs

This document describes supported configuration files that keeps local and unique on different machines.

All these custom configs are saved in `[$nu.default-conf-dir, custom] | path join` directory.

Configs may be **required** or optional according to their usage.

To add more config files, `use` them in your `env.nu` (or `config.nu`, which is less preferred).

For example, to use `foo.nu`:

```nu
const foo_mod = if ([$nu.default-config-dir, "custom", "foo.nu"] | path join | path exists) { "./custom/foo.nu" }
use $foo_mod *
```

> ref: https://github.com/nushell/nushell/discussions/16679#discussioncomment-14391728


## Install

```nu
mkdir ~/.config/nushell
ln -sf $"($env.PWD)/bin" ~/.config/nushell/bin
ln -sf $"($env.PWD)/config.nu" ~/.config/nushell/config.nu
ln -sf $"($env.PWD)/env.nu" ~/.config/nushell/env.nu
ln -sf $"($env.PWD)/log.nu" ~/.config/nushell/log.nu
ln -sf $"($env.PWD)/nufmt.nuon" ~/.config/nushell/nufmt.nuon
ln -sf $"($env.PWD)/custom" ~/.config/nushell/custom
cp ~/.config/nushell/custom/custom_env.example.nu ~/.config/nushell/custom/custom_env.nu
```

## Custom env

Saved in `custom_env.nu`.

Define custom environment variables in this file.

### Example

**See [custom_env.nu](./custom/custom_env.nu).**

Used envs:

- `NVIM_CUSTOM_COLORSCHEME`, value is string, colorscheme name, e.g. "catppuccin-mocha".
- `WEZTERM_CONFIG_PATH`, value is the `.wezterm.lua` file path.
- `NVIM_CUSTOM_TRANSPARENT_BACKGROUND`, value is `true` or `false` or not set, controls transparent colorscheme background in neovim.
- `NVIM_CUSTOM_USE_DARK_MODE`, value is `true` or `false` or not set, controls `vim.o.background`.
- `NVIM_CUSTOM_USE_NUSHELL`, value is `true` or `false` or not set, use nushell as the shell in nvim.
- `NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME`, value is `true` or `false` or not set, sync neovim theme to wezterm when neovim theme changed.
- `NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME`, value is `true` or `false` or not set, sync neovim to neovim config file when neovim theme changed.
- `NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME`, value is `true` or `false` or not set, sync neovim theme to alacritty config file when neovim theme changed.
- `NVIM`, value is `nvim` to let zellij use nvim as the editor when `EditScrollback`.
- `NVIM_RUNTIME_DIR`, value is the path to `runtime` directory in neovim directory. This variable is used for loading neovim symbols when editing neovim config.
- `GPG_TTY`, run external tty command so that gpg command print prompts in terminal.

## Custom alias

Saved in `custom_alias.nu`.

Save custom alias in this file.

## Custom path

Add custom `$env.PATH` variable values in `custom_path.nu`

```nu
export def define_custom_path [] {
    return [
        "/path/to/add/to/PATH",
    ]
}
```

### Example

```nu
export alias foo = bar | baz
```
