local use_dark_mode = os.getenv('NVIM_CUSTOM_USE_DARK_MODE')
if (use_dark_mode) then
	vim.o.background = 'dark'
end

-- Setup colorscheme
-- github_dark
-- github_dark_dimmed
-- github_dark_tritanopia
-- github_dark_default
-- github_dark_colorblind
-- github_dark_high_contrast
-- gruvbox
-- nightfox
-- nordfox
-- terafox
-- carbonfox
-- duskfox
-- onedark
-- tokyonight-moon
-- tokyonight-night
-- tokyonight-storm
-- onedark
-- catppuccin
-- catppuccin-macchiato
-- catppuccin-mocha
-- hardhacker
-- hardhacker-darker
-- monokai-pro
-- monokai-pro-classic
-- monokai-pro-default
-- monokai-pro-machine
-- monokai-pro-octagon
-- monokai-pro-ristretto
-- monokai-pro-spectrum
-- kanagawa-paper
-- kanagawa-wave
-- kanagawa-dragon
-- kanagawa-lotus

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
