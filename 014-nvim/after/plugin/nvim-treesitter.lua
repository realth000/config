local status, plugin = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

plugin.setup({
	ensure_installed = { 'cmake', 'cpp', 'dart', 'diff', 'gitcommit', 'go', 'python', 'toml', 'yaml', 'vim' },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = { 'html' },
	},
})
