-- Set floating window background color to transparent after loading colorscheme
vim.api.nvim_set_hl(0, 'NormalFloat', {bg='None'})

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

local colorscheme = os.getenv('NVIM_CUSTOM_COLORSCHEME')
if (colorscheme) then
	vim.cmd('colorscheme ' .. colorscheme)
end

