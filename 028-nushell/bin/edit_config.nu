# This script is ONLY intend to use in nushell REPL.

module internal {
    export def fatal [
        error: string
        help?: string
        exit_code: int = 1
    ] {
        use ../log.nu fatal
        fatal "ec" $error $help $exit_code
    }

    def required_env [] {
        return [WEZTERM_CONFIG_PATH]
    }

    def check_envs [] {
        let env_names = $env | columns
        let invalid_env = required_env | where { |x| $env_names | all { |y| $y != $x } }
        if ($invalid_env | is-not-empty) {
            fatal $"envs not found: ($invalid_env)"
        }
    }

    export def all_targets [] { return [
        {
            target: "nu"
            detail: "nushell config"
            path: $"($nu.default-config-dir)"
        }
        {
            target: "wz"
            detail: "wezterm config"
            path: $"($env.WEZTERM_CONFIG_PATH)"
        }
        {
            target: "nv"
            detail: "neovim config"
            path: $"($env.HOME)/.config/nvim"
        }
    ] }
}

# Edit config
#
# A shortcut to edit config files for different targets
export def ec [
    target?: string # Target config name
    --print-targets(-p) # Print all available targets
] {
    use internal *

    if $print_targets {
        print "all available targets:"
        print $"(all_targets | to json)"
        return
    }

    if ($target | is-empty) {
        fatal "target not set" "* Use `ec <target>` to edit targeted config\n* Use `ec -p/--print-target to check all configs available"
    }

    let target_path = all_targets | where $it.target == $target | get path
    if ($target_path | is-empty) {
        fatal "invalid target" $"invalid target ($target)"
    }

    with-env { "NVIM_NO_LSP": 1 } { nvim $target_path.0 }
}
