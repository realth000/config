local status, plugin = pcall(require, 'ibl')
if (not status) then return end

vim.opt.termguicolors = true

local highlight = {
	'Rainbow1',
	'Rainbow2',
	'Rainbow3',
	'Rainbow4',
	'Rainbow5',
}

local hooks_status, hooks = pcall(require, 'ibl.hooks')
if (not hooks_status) then return end
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, 'Rainbow1', { fg = '#483f25' })
	vim.api.nvim_set_hl(0, 'Rainbow2', { fg = '#2b3c2b' })
	vim.api.nvim_set_hl(0, 'Rainbow3', { fg = '#253a4b' })
	vim.api.nvim_set_hl(0, 'Rainbow4', { fg = '#30435a' })
	vim.api.nvim_set_hl(0, 'Rainbow5', { fg = '#1f3735' })
end)

vim.opt.list = true
vim.opt.listchars:append 'space:⋅'
vim.g.rainbow_delimiters = { highlight = highlight }

plugin.setup {
	indent = {
		highlight = highlight,
		char = '▏',
	},
	scope = {
		enabled = false,
	},
}

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
