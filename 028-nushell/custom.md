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
     "NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME": "true"
   }
}
```

The code above defines two envs:

1. `NVIM_CUSTOM_COLORSCHEME`, value is string, colorscheme name, e.g. "catppuccin-mocha".
2. `WEZTERM_CONFIG_PATH`, value is the `.wezterm.lua` file path.
3. `NVIM_CUSTOM_TRANSPARENT_BACKGROUND`, value is `true` or `false` or not set, controls transparent colorscheme background in neovim.
4. `NVIM_CUSTOM_USE_DARK_MODE`, value is `true` or `false` or not set, controls `vim.o.background`.
5. `NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME`, value is `true` or `false` or not set, sync neovim theme to wezterm when neovim theme changed.

## Custom alias

Saved in `custom_alias.nu`.

Save custom alias in this file.

### Example

```nu
export alias foo = bar | baz
```
