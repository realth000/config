local status, plugin = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

plugin.setup({
	ensure_installed = {
		'cmake',
		'bash',
		'cpp',
		'dart',
		'diff',
		'doxygen',
		'gitcommit',
		'go',
		'javascript',
		'lua',
		'markdown',
		'markdown_inline',
		'python',
		'regex',
		'rust',
		'toml',
		'yaml',
		'qmljs',
		'vala',
		'typescript',
		'vim',
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = { 'html' },
	},
})
