local use_dark_mode = os.getenv('NVIM_CUSTOM_USE_DARK_MODE')
if (use_dark_mode) then
	vim.o.background = 'dark'
end

-- Setup colorscheme
--
-- carbonfox
-- catppuccin
-- catppuccin-macchiato
-- catppuccin-mocha
-- duskfox
-- github_dark
-- github_dark_dimmed
-- github_dark_tritanopia
-- github_dark_default
-- github_dark_colorblind
-- github_dark_high_contrast
-- gruvbox
-- hardhacker
-- hardhacker-darker
-- monokai-pro
-- monokai-pro-classic
-- monokai-pro-default
-- monokai-pro-machine
-- monokai-pro-octagon
-- monokai-pro-ristretto
-- monokai-pro-spectrum
-- nightfox
-- nordfox
-- jellybeans
-- kanagawa-paper
-- kanagawa-wave
-- kanagawa-dragon
-- kanagawa-lotus
-- onedark
-- palenight
-- terafox
-- tokyonight-moon
-- tokyonight-night
-- tokyonight-storm

local colorscheme = os.getenv('NVIM_CUSTOM_COLORSCHEME')
if (colorscheme) then
	vim.cmd('colorscheme ' .. colorscheme)
end

-- Override the floating window style.
--
-- Some colorschemes do not setup 'FloatBorder.bg' and some may setup the
-- background color to highlighted value.
--
-- Let's call this function to make a transparent background floating window.
--
-- Note that this function should be called after colorscheme is setup.
local function override_float_window_style()
	local norm_hl = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
	local border_hl = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })

	vim.api.nvim_set_hl(0, 'NormalFloat', { fg = norm_hl.fg, bg = 'None' })
	vim.api.nvim_set_hl(0, 'FloatBorder', { fg = border_hl.fg, bg = 'None' })
end

override_float_window_style()

-- Add autocmd for syncing wezterm config.
--
-- Only sync theme when all these conditions are met:
--
-- 1. `NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME` set to `true`.
-- 2. `nu` is an executable globally, e.g. in `$PATH`.
--
-- To sync theme with wezterm, `$nu.default-config-dir/bin/wezterm_set_theme.nu` MUST exists.
local sync_wezterm_theme = os.getenv('NVIM_CUSTOM_SYNC_WEZTERM_COLORSCHEME')
if (sync_wezterm_theme == 'true') and (vim.fn.executable('nu') == 1) then
	vim.api.nvim_create_autocmd('ColorScheme', {
		callback = function(args)
			local theme = args.match
			local nu_dir = vim.fn.system({ "nu", "-c", "$nu.default-config-dir" }):gsub("%s+", "")
			local script_path = vim.fs.joinpath(nu_dir, "bin", "wezterm_set_theme.nu")
			local subcommand = vim.system({ "nu", script_path, theme }, { text = true }):wait()
			local result = string.format("[%s] %s", subcommand.code, subcommand.stdout)
			print(result)
		end
	})
end

-- Add autocmd for syncing nvim theme config in file.
--
-- Only sync theme value in file.
--
-- 1. `NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME` set to `true`.
-- 2. `nu` is an executable globally, e.g. in `$PATH`.
--
-- To sync theme value to config file, `$nu.default-config-dir/bin/nvim_set_theme.nu` MUST exists.
local sync_nvim_theme = os.getenv('NVIM_CUSTOM_SYNC_NVIM_COLORSCHEME')
if (sync_nvim_theme == 'true') and (vim.fn.executable('nu') == 1) then
	vim.api.nvim_create_autocmd('ColorScheme', {
		callback = function(args)
			local theme = args.match
			local nu_dir = vim.fn.system({ "nu", "-c", "$nu.default-config-dir" }):gsub("%s+", "")
			local script_path = vim.fs.joinpath(nu_dir, "bin", "nvim_set_theme.nu")
			local subcommand = vim.system({ "nu", script_path, theme }, { text = true }):wait()
			local result = string.format("[%s] %s", subcommand.code, subcommand.stdout)
			print(result)
		end
	})
end

-- Add autocmd for syncing alacritty config in file.
--
-- Only sync theme value in file.
--
-- 1. `NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME` set to `true`.
-- 2. `nu` is an executable globally, e.g. in `$PATH`.
-- 3. `alacritty` is an executable globally, e.g. in `$PATH`.
--
-- To sync theme value to config file, `$nu.default-config-dir/bin/alacritty_set_theme.nu` MUST exists.
local sync_alacritty_theme = os.getenv('NVIM_CUSTOM_SYNC_ALACRITTY_COLORSCHEME')
if (sync_alacritty_theme == 'true') and (vim.fn.executable('nu') == 1) and (vim.fn.executable('alacritty') == 1) then
	vim.api.nvim_create_autocmd('ColorScheme', {
		callback = function(args)
			local theme = args.match
			local nu_dir = vim.fn.system({ "nu", "-c", "$nu.default-config-dir" }):gsub("%s+", "")
			local script_path = vim.fs.joinpath(nu_dir, "bin", "alacritty_update_config.nu")
			local subcommand = vim.system({ "nu", script_path, "--theme", theme }, { text = true }):wait()
			local result = string.format("[%s] %s", subcommand.code, subcommand.stdout)
			print(result)
		end
	})
end
