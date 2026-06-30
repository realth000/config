# Set nvim theme in config.
#
# The nvim theme value MUST be saved in $nu.default-config-dir/custom_env.nu.
@category nvim
@example "Set nvim theme to catppuccin-mocha" { nvim_set_theme.nu catppuccin-mocha }
def main [theme: string] {
    if ($theme | is-empty) {
        print "no theme name provided in args"
        return 1
    }

    const file = $nu.default-config-dir | path join "custom" | path join "custom_env.nu"
    if not ($file | path exists) {
        print "failed to sync nvim theme: custom_env.nu not exists"
        return 1
    }

    open $file
    | str replace -r "([^\"]+)\"?NVIM_CUSTOM_COLORSCHEME.?: ?\".+\"" $"$1\"NVIM_CUSTOM_COLORSCHEME\": \"($theme)\""
    | save -f $file

    print $"nvim theme changed to ($theme) at ($file)"
}
