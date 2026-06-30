# Set wezterm theme in config.
#
# The wezterm config file path MUST be placed in $nu.default-config-dir/custom_env.nu and exists.
@category wezterm
@example "Set wezterm theme to catppuccin-mocha" { wezterm_set_theme.nu catppuccin-mocha }
def main [theme: string] {
    if ($theme | is-empty) {
        print "no theme name provided in args"
        return 1
    }

    const file = $nu.default-config-dir | path join "custom" | path join "custom_env.nu"
    if not ($file | path exists) {
        print "failed to locate wezterm.lua: custom_env.nu not exists"
        return 1
    }

    use $file define_custom_env
    let wezterm_config_path = define_custom_env | get -o WEZTERM_CONFIG_PATH
    if $wezterm_config_path == null {
        print "no config path ins custom_env.nu"
        return 2
    }

    if not ($wezterm_config_path | path exists) {
        print $"wezterm config file not exists: ($wezterm_config_path)"
        return 3
    }

    open $wezterm_config_path
    | str replace -r "local colorscheme = '[^']+' -- @@WEZTERM_COLORSCHEME@@" $"local colorscheme = '($theme)' -- @@WEZTERM_COLORSCHEME@@"
    | save -f $wezterm_config_path

    print $"wezterm theme changed to ($theme) at ($wezterm_config_path)"
}
