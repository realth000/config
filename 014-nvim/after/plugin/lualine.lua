local status, plugin = pcall(require, 'lualine')
if (not status) then return end

-- All lualine theme map assosiated with nvim colorscheme
local theme_map = {
	-- Nightfly
	["nightfly"] = "nightfly",

	-- Gruvbox
	["gruvbox"] = "gruvbox_dark",

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
	["catppuccin-macchiato"] = "catppuccin",
	["catppuccin-mocha"] = "catppuccin",
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
		-- component_separators = { left = '', right = ''},
		-- section_separators = { left = '', right = ''},
		-- component_separators = { left = '/', right = '/'},
		section_separators = { left = '', right = '' },
		-- section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
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
		lualine_b = { 'branch', 'diff', 'diagnostics' },
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
	tabline = {
		-- lualine_a = { 'buffers' },
		-- lualine_b = {'branch'},
		-- lualine_c = { 'filename' },
		-- lualine_x = {},
		-- lualine_y = {},
		-- lualine_z = { 'tabs' }
	},
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
