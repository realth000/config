local status, plugin = pcall(require, 'tree-sitter-manager')
if (not status) then return end

plugin.setup({
	-- Default Options
	-- list of parsers to install at the start of a neovim session
	ensure_installed = {
		'c',
		'cmake',
		'bash',
		'cpp',
		'dart',
		'diff',
		'doxygen',
		'gitcommit',
		'gleam',
		'go',
		'hyprlang',
		'javascript',
		'json',
		'lua',
		'nim',
		'ninja',
		'nu',
		'markdown',
		'markdown_inline',
		'nginx',
		'objdump',
		'passwd',
		'python',
		'qmljs',
		'regex',
		'rust',
		'toml',
		'typescript',
		'yaml',
		'xml',
		'vala',
		'vim',
		'zig',
	},
	-- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
	-- auto_install = false, -- if enabled, install missing parsers when editing a new file
	-- highlight = true, -- treesitter highlighting is enabled by default
	-- languages = {}, -- override or add new parser sources
	-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
	-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
})
