# All avilable colorschemes for alacritty.
const alacritty_colorschemes = {
    "catppuccin-frappe": "catppuccin-frappe",
    "catppuccin-latte": "catppuccin-latte",
    "catppuccin-macchiato": "catppuccin-macchiato",
    "catppuccin-mocha": "catppuccin-mocha",
    "dawnfox": "dawnfox",
    "hardhacker": "hardhacker",
    "hardhacker-darker": "hardhacker",
    "kanagawa-dragon": "kanagawa_dragon",
    "kanagawa-paper": "kanagawa_wave",
    "kanagawa-wave": "kanagawa_wave",
    "monokai": "monokai",
    "monokai-pro": "monokai",
    "monokai-pro-classis": "monokai",
    "monokai-pro-default": "monokai",
    "monokai-pro-machine": "monokai",
    "monokai-pro-octagon": "monokai",
    "monokai-pro-ristretto": "monokai",
    "monokai-pro-spectrum": "monokai",
    "nightfly": "nightfly",
    "nightfox": "nightfox",
    "nord": "nord",
    "nordfox": "nordfox",
    "nordic": "nord",
    "terafox": "terafox",
    "tokyonight": "tokyo-night-storm",
    "tokyonight-storm": "tokyo-night-storm",
    "tokyonight-moon": "tokyo-night-storm",
    "palenight": "palenight"
}

# Set alacritty theme in config.
@category alacritty
@example "Set alacritty theme to catppuccin-mocha" { alacritty_set_theme.nu catppuccin-mocha }
def main [theme: string] {
    if ($theme | is-empty) {
        print "no theme name provided in args"
        return 1
    }

    # Update the config in `custom/custom.toml` in alacritty config directory,
    # we only intend to modify custom configs so that to keep the git repository clean.
    let alacritty_config_path = if $nu.os-info.name == "windows" {
        [$env.APPDATA, "alacritty", "custom", "custom.toml"] | path join
    } else {
        [$env.HOME, ".config" "alacritty", "custom", "custom.toml"] | path join
    }

    if $alacritty_config_path == null {
        print "no config path ins custom_env.nu"
        return 2
    }

    if not ($alacritty_config_path | path exists) {
        print $"alacritty config file not exists: ($alacritty_config_path)"
        return 3
    }

    let parsed_theme = $alacritty_colorschemes | get -o $theme

    if parsed_theme == null {
        print $"alacritty unknown theme: ($theme)"
        return 4
    }

    open $alacritty_config_path
    | update general.import [$"../themes/($parsed_theme).toml"]
    | save -f $alacritty_config_path

    print $"alacritty theme changed to ($theme) at ($alacritty_config_path)"
}
