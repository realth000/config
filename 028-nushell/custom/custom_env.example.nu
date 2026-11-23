# Load customized environments from the script.
#
# Note that `$env.PATH` MUST be loaded in custom_path.nu instead of this file.
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
        "EDITOR": "nvim"
        "NVIM_RUNTIME_DIR": "/path/to/nvim/runtime"
        "NVIM_MODULE_DIR": $"(load_nvim_module_dirs)"
        # "GPG_TTY": $"(tty)" # Required by gpg command for prompt input sometimes, in wsl.
    }
}

def load_nvim_module_dirs []: nothing -> string {
    let NVIM_MODULE_BASE_DIR = if $nu.os-info.name == "windows" {
        $"($env.LOCALAPPDATA)/nvim-data/share/nvim/lazy"
    } else {
        $"($env.HOME)/.local/share/nvim/lazy"
    }

    if not ($NVIM_MODULE_BASE_DIR | path exists) {
        return ""
    }

    mut dirs = []
    for path in (ls $NVIM_MODULE_BASE_DIR) {
        $dirs = $dirs | append $path.name
    }

    return ($dirs | str join ':')
}
