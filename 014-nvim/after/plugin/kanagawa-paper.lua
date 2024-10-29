local status, plugin = pcall(require, 'kanagawa-paper')
if (not status) then return end

plugin.setup({
	undercurl = true,
	transparent = false,
	gutter = false,
	dimInactive = true, -- disabled when transparent
	terminalColors = true,
	commentStyle = { italic = true },
	functionStyle = { italic = false },
	keywordStyle = { italic = false, bold = false },
	statementStyle = { italic = false, bold = false },
	typeStyle = { italic = false },
	colors = { theme = {}, palette = {} }, -- override default palette and theme colors
	overrides = function()              -- override highlight groups
		return {}
	end,
})
