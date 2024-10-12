# custom_env.nu

This doc explains an example to define custom environment variables in another nushell script file called `custom_env.nu`

`custom_env.nu` is saved in `$nu.default-conf-dir`.

## Content

```nu
#!/usr/bin/env nu
export def define_custom_env [] {
   {
     "NVIM_CUSTOM_COLORSCHEME": "monokai-pro-spectrum",
     "WEZTERM_CONFIG_PATH": $"($env.HOME)/.wezterm.lua",
   }
}
```

The code above defines two envs:

1. `NVIM_CUSTOM_COLORSCHEME`, value is string "monokai-pro-spectrum".
2. `WEZTERM_CONFIG_PATH`, value is `.wezterm.lua` in current user's home directory.

## Usage

To use or import them in `env.nu`, add the following code to `env.nu`

```nu
use custom_env.nu define_custom_env
define_custom_env | load-env
```

First use `use` keyword to import `define_custom_env` command which defined in `$nu.default-conf-dir/custom_env.nu`,

Then call `define_custom_env` will load envs into pipe and finally call `load-env` to take effect.

Note that when using `use` to import a nushell module (this time is a file called "custom_env.nu"), the default import path is `$nu.default-conf-dir`.

So that do NOT prepent diretory path before module name.

But in a more robust example, it's better to check whether the module file `custom_env.nu` exists or not before importing it, this time explicitly prepend directory path.

```nu
if ($nu.default-config-dir | path join "custom_env.nu" | path exists) {
  use custom_env.nu define_custom_env
  define_custom_env | load-env
} else {
  print "custom.nu not found in nu default-config-dir"
}
```

Complete code above first check `custom_env.nu` exists or not.

* If exists, load envs.
* If not exists, print a log to indicate that.

