-- Init lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ 'git', 'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({

	-- Color scheme
	{
		'navarasu/onedark.nvim',
		'ellisonleao/gruvbox.nvim',
		'projekt0n/github-nvim-theme',
		'folke/tokyonight.nvim',
		'EdenEast/nightfox.nvim',
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},
		{
			'hardhackerlabs/theme-vim',
			name = 'hardhacker',
		},
		{
			"loctvl842/monokai-pro.nvim",
			lazy = true,
		},
		{ 'kepano/flexoki-neovim',      name = 'flexoki' },
		{ "bluz71/vim-nightfly-colors", name = "nightfly" },
		'AlexvZyl/nordic.nvim',
		'luisiacc/gruvbox-baby',
		{ 'rose-pine/neovim',          name = 'rose-pine', },
		{ 'kepano/flexoki-neovim',     name = 'flexoki', },
		{ "bluz71/vim-moonfly-colors", name = "moonfly", },
		{ 'rebelot/kanagawa.nvim' },
		{ 'sho-87/kanagawa-paper.nvim' },
	},

	-- nvim-tree
	{ 'kyazdani42/nvim-tree.lua' },
	{ 'kyazdani42/nvim-web-devicons', lazy = true },

	-- lualine
	{
		'nvim-lualine/lualine.nvim',
		{ 'kyazdani42/nvim-web-devicons' },
	},

	-- -- tabline
	-- {
	-- 	'romgrk/barbar.nvim',
	-- 	dependencies = {
	-- 		'lewis6991/gitsigns.nvim',
	-- 		'nvim-tree/nvim-web-devicons',
	-- 	},
	-- },
	-- -- bufferline
	-- {
	-- 	'akinsho/bufferline.nvim',
	-- 	dependencies = 'nvim-tree/nvim-web-devicons'
	-- },


	-- treesitter, hightlight
	{ 'nvim-treesitter/nvim-treesitter', cmd = 'TSUpdate', },

	-- lsp
	{
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp',
		'hrsh7th/vim-vsnip', -- Fix dart snippet only
	},

	-- rust-tools takes over some rust lsp configs.
	-- DEPRECATED
	-- { 'simrat39/rust-tools.nvim', },

	-- { 'mrcjkb/rustaceanvim', },

	{ "onsails/lspkind.nvim", },

	-- Auto complete brackts
	{ 'windwp/nvim-autopairs', },

	-- telescope
	{
		'nvim-telescope/telescope.nvim',
		{
			'nvim-lua/plenary.nvim',
			lazy = true,
		},
	},

	-- GitSigns
	{ 'lewis6991/gitsigns.nvim', },

	{ 'vala-lang/vala.vim', },

	-- Terminal
	{ 'numToStr/FTerm.nvim', },

	-- Symbol outline
	{ 'stevearc/aerial.nvim', },

	-- Blankline indent color
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
	},

	-- Rainbow brackts
	{ "HiPhish/rainbow-delimiters.nvim", },

	-- Notice, command line.
	{
		"folke/noice.nvim",
		{ 'MunifTanjim/nui.nvim', lazy = true, },
	},

	-- Sync terminal background color
	{
		"typicode/bg.nvim",
	},

	-- Syntax highlighting for nushell format
	{
		'LhKipp/nvim-nu',
	},

	-- Markdown
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you use the mini.nvim suite
	}
})
