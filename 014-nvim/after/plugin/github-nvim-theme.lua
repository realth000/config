local status, plugin = pcall(require, 'github-theme')
if (not status) then return end

-- Default options
plugin.setup({
	options = {
		-- Compiled file's destination location
		compile_path = vim.fn.stdpath('cache') .. '/github-theme',
		compile_file_suffix = '_compiled', -- Compiled file suffix
		hide_end_of_buffer = true,   -- Hide the '~' character at the end of the buffer for a cleaner look
		hide_nc_statusline = true,   -- Override the underline style for non-active statuslines
		transparent = true,         -- Disable setting background
		terminal_colors = true,      -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = false,        -- Non focused panes set to alternative background
		module_default = true,       -- Default enable value for modules
		styles = {                   -- Style to be applied to different syntax groups
			comments = 'italic',     -- Value is any valid attr-list value `:help attr-list`
			functions = 'NONE',
			keywords = 'italic',
			variables = 'NONE',
			conditionals = 'NONE',
			constants = 'NONE',
			numbers = 'NONE',
			operators = 'NONE',
			strings = 'NONE',
			types = 'NONE',
		},
		inverse = { -- Inverse highlight for different types
			match_paren = false,
			visual = false,
			search = false,
		},
		darken = { -- Darken floating windows and sidebar-like windows
			floats = false,
			sidebars = {
				enable = true,
				list = {}, -- Apply dark background to specific windows
			},
		},
		modules = { -- List of various plugins and additional options
			-- ...
		},
	},
	palettes = {},
	specs = {},
	groups = {},
})

-- -- Example config in Lua
-- require('github-theme').setup({
--   -- theme_style = 'dark',
--   function_style = 'italic',
--   sidebars = {'qf', 'vista_kind', 'terminal', 'packer'},
--
--   -- Change the 'hint' color to the 'orange' color, and make the 'error' color bright red
--   -- colors = {hint = 'orange', error = '#ff0000'},
--
--   -- Overwrite the highlight groups
--   overrides = function(c)
--     return {
--       htmlTag = {fg = c.red, bg = '#282c34', sp = c.hint, style = 'underline'},
--       DiagnosticHint = {link = 'LspDiagnosticsDefaultHint'},
--       -- this will remove the highlight groups
--       TSField = {},
--     }
--   end
-- })
