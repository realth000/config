local status, plugin = pcall(require, 'lualine')
if (not status) then return end

local kanagawa_paper = require("lualine.themes.kanagawa-paper-ink")

-- All lualine theme map assosiated with nvim colorscheme
local theme_map = {
	-- Nightfly
	["nightfly"] = "nightfly",

	-- Gruvbox
	["gruvbox"] = "gruvbox_dark",
	["gruvbox-baby"] = "gruvbox_dark",

	-- Monokai pro
	["monokai-pro"] = "monokai-pro",
	["monokai-pro-classic"] = "monokai-pro",
	["monokai-pro-default"] = "monokai-pro",
	["monokai-pro-machine"] = "monokai-pro",
	["monokai-pro-octagon"] = "monokai-pro",
	["monokai-pro-ristretto"] = "monokai-pro",
	["monokai-pro-spectrum"] = "monokai-pro",

	-- Onedark
	["onedark"] = "onedark",

	-- Catppuccin
	["catppuccin"] = "catppuccin",
	["catppuccin-macchiato"] = "catppuccin-macchiato",
	["catppuccin-mocha"] = "catppuccin-mocha",
	["catppuccin-latte"] = "catppuccin-latte",

	-- Moonfly
	["moonfly"] = "moonfly",

	-- kanagawa-paper
	["kanagawa-paper"] = kanagawa_paper,
	["kanagawa"] = kanagawa_paper,
	["kanagawa-wave"] = kanagawa_paper,
	["kanagawa-dragon"] = kanagawa_paper,
	["kanagawa-lotus"] = kanagawa_paper,

	-- gleam
	["gleam"] = "gleam",

	-- nightfox
	-- Ensure nightfox theme is installed.
	["nightfox"] = "nightfox",
	["nordfox"] = "nordfox",
	["duskfox"] = "duskfox",
	["carbonfox"] = "carbonfox",
	["terafox"] = "terafox",

	-- nordic
	["nordic"] = "nord",

	-- palenight
	["palenight"] = "palenight",

	-- jellybeans
	["jellybeans"] = "jellybeans",
}

-- Fallback theme.
local fallback_theme = "palenight"

-- Currrent nvim colorscheme.
local colorscheme = os.getenv('NVIM_CUSTOM_COLORSCHEME')

-- Finally selected lualine theme.
local theme = theme_map[colorscheme] or fallback_theme

plugin.setup {
	options = {
		icons_enabled = true,
		-- See https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
		-- palenight moonfly codedark gruvbox-material horizon material nightfly onedark
		-- powerline_dark solarized_dark jellybeans everforest gruvbox_dark iceberg_dark modus-vivendi wombat papercolor_dark
		theme = theme,
		-- section_separators = { left = '', right = '' },
		-- section_separators = { left = '', right = '' },
		-- section_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		-- component_separators = { left = '', right = ''},
		-- component_separators = { left = '/', right = '/'},
		-- component_separators = { left = '', right = '' },
		-- component_separators = { left = '│', right = '│' },
		component_separators = { left = '', right = '' },
		--     disabled_filetypes = {
		--       statusline = {},
		--       winbar = {},
		--     },
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = {
			'branch',
			'diff',
			{
				'diagnostics',
				-- Table of diagnostic sources, available sources are:
				--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
				-- or a function that returns a table as such:
				--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
				sources = { 'nvim_lsp', 'nvim_diagnostic' },
				-- Displays diagnostics for the defined severity types
				sections = { 'error', 'warn', 'info', 'hint' },
				-- diagnostics_color = {
				-- 	error = 'DiagnosticError',
				-- 	warn  = 'DiagnosticWarn',
				-- 	info  = 'DiagnosticInfo',
				-- 	hint  = 'DiagnosticHint',
				-- },
				symbols = {error = '⨯', warn = '󰀪', info = 'ℹ', hint = '󰌶'},
				colored = true,           -- Displays diagnostics status in color if set to true.
				update_in_insert = false, -- Update diagnostics in insert mode.
				always_visible = false,   -- Show diagnostics even if there are none.
			},
		},
		lualine_c = {
			'filename',
			{
				'aerial',

				-- The separator to be used to separate symbols in status line.
				sep = ' > ',

				-- The number of symbols to render top-down. In order to render only 'N' last
				-- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
				-- be used in order to render only current symbol.
				depth = 4,

				-- When 'dense' mode is on, icons are not rendered near their symbols. Only
				-- a single icon that represents the kind of current symbol is rendered at
				-- the beginning of status line.
				dense = true,

				-- The separator to be used to separate symbols in dense mode.
				dense_sep = '.',

				colored = false,
			},
		},
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	-- tabline = {
	-- 	lualine_a = { 'buffers' },
	-- 	-- lualine_b = {'branch'},
	-- 	-- lualine_c = { 'filename' },
	-- 	-- lualine_x = {},
	-- 	-- lualine_y = {},
	-- 	-- lualine_z = { 'tabs' }
	-- },
	winbar = {
		-- lualine_a = {},
		-- lualine_b = {},
		-- lualine_c = {'filename'},
		-- lualine_x = {},
		-- lualine_y = {},
		-- lualine_z = {}
	},
	inactive_winbar = {},
	extensions = {}
}

-- Get or set lualine colorscheme.
--
-- If args is not provided, print current colorscheme name.
-- If args is provided, use it as the colorscheme name to set.
local function lualineColorScheme(args)
	local theme = args.args
	local status, lualine = pcall(require, 'lualine')
	if (not status) then return end

	if (theme == nil or theme == '') then
		print(vim.inspect(lualine.get_config().options.theme))
	else
		lualine.setup({ options = { theme = theme } })
	end
end

vim.api.nvim_create_user_command('LualineColorscheme', lualineColorScheme, { nargs='?', desc = 'Get or set Lualine colorscheme'})

-- Sync lualine theme after nvim colorscheme changed.
vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = '*',
	callback = function()
		local nvim_colorscheme = vim.g.colors_name
		local theme = theme_map[nvim_colorscheme] or fallback_theme
		plugin.setup({ options = { theme = theme } })
	end,
})
