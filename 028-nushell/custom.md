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

## Custom env

Saved in `custom_env.nu`.

Define custom environment variables in this file.

### Example

```nu
export def define_custom_env [] {
   {
     "NVIM_CUSTOM_COLORSCHEME": "catppuccin-mocha"
     "WEZTERM_CONFIG_PATH": $"($env.HOME)/.wezterm.lua"
     "NVIM_CUSTOM_TRANSPARENT_BACKGROUND": "false"
     "NVIM_CUSTOM_USE_DARK_MODE": "true"
     "NVIM_CUSTOM_USE_NUSHELL": "true"
     "NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME": "true"
     "NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME": "true"
     "NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME": "true"
   }
}
```

The code above define envs:

- `NVIM_CUSTOM_COLORSCHEME`, value is string, colorscheme name, e.g. "catppuccin-mocha".
- `WEZTERM_CONFIG_PATH`, value is the `.wezterm.lua` file path.
- `NVIM_CUSTOM_TRANSPARENT_BACKGROUND`, value is `true` or `false` or not set, controls transparent colorscheme background in neovim.
- `NVIM_CUSTOM_USE_DARK_MODE`, value is `true` or `false` or not set, controls `vim.o.background`.
- `NVIM_CUSTOM_USE_NUSHELL`, value is `true` or `false` or not set, use nushell as the shell in nvim.
- `NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME`, value is `true` or `false` or not set, sync neovim theme to wezterm when neovim theme changed.
- `NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME`, value is `true` or `false` or not set, sync neovim to neovim config file when neovim theme changed.
- `NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME`, value is `true` or `false` or not set, sync neovim theme to alacritty config file when neovim theme changed.

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
