local status, plugin = pcall(require, 'gruvbox')
if (not status) then return end

---@type GruvboxConfig | table
local config = {
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = true,
		operators = true,
		comments = true,
	},
	strikethrough = true,
	invert_selection = false,
	invert_signs = false,
	invert_tabline = false,
	invert_intend_guides = false,
	inverse = true, -- invert background for search, diffs, statuslines and errors
	contrast = '',  -- can be 'hard', 'soft' or empty string
	palette_overrides = {},
	overrides = {},
	dim_inactive = false,
	transparent_mode = GetThemeUseTransparent(),
}

---@cast plugin Gruvbox
plugin.setup(config)
