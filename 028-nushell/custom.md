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
     "NVIM_CUSTOM_COLORSCHEME": "catppuccin-mocha",
     "WEZTERM_CONFIG_PATH": $"($env.HOME)/.wezterm.lua",
   }
}
```

The code above defines two envs:

1. `NVIM_CUSTOM_COLORSCHEME`, value is string "monokai-pro-spectrum".
2. `WEZTERM_CONFIG_PATH`, value is `.wezterm.lua` in current user's home directory.

## Custom alias

Saved in `custom_alias.nu`.

Save custom alias in this file.

### Example

```nu
export alias foo = bar | baz
```
