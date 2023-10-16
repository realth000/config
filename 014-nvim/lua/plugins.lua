return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Color scheme
	use {
		'navarasu/onedark.nvim'
	}

	use {
		'ellisonleao/gruvbox.nvim'
	}

	use {
		'projekt0n/github-nvim-theme'
	}

	use {
		'folke/tokyonight.nvim'
	}

	use {
		'EdenEast/nightfox.nvim'
	}

	use { "catppuccin/nvim", as = "catppuccin" }

	use { 'hardhackerlabs/theme-vim', as = 'hardhacker' }

	-- nvim-tree
	use {
		'kyazdani42/nvim-tree.lua',
		requires = 'kyazdani42/nvim-web-devicons'
	}

	-- airline, recommand to use lualine in neovim.
	-- use {
	--   'vim-airline/vim-airline',
	--   'vim-airline/vim-airline-themes'
	-- }

	-- lualine
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			'kyazdani42/nvim-web-devicons',
			opt = true,
		}
	}

	-- treesitter, hightlight
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
		-- Run after first install:
		-- :TSInstall cmake cpp dart diff gitcommit go python toml yaml vim
	}

	-- lsp
	use {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp',
		'hrsh7th/vim-vsnip', -- Fix dart snippet only
	}

	-- rust-tools takes over some rust lsp configs.
	use {
		'simrat39/rust-tools.nvim'
	}

	use {
		"onsails/lspkind.nvim"
	}

	-- Auto complete brackts
	use {
		'windwp/nvim-autopairs',
	}

	-- telescope
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	-- GitSigns
	use {
		'lewis6991/gitsigns.nvim',
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	}

	use {
		'vala-lang/vala.vim',
	}

	-- Terminal
	use {
		'numToStr/FTerm.nvim'
	}

	-- Symbol outline
	use {
		'stevearc/aerial.nvim',
	}

	-- -- Copilot
	-- use {
	-- 	"zbirenbaum/copilot.lua"
	-- }

	-- Blankline indent color
	use {
		"lukas-reineke/indent-blankline.nvim",
		commit = "9637670896b68805430e2f72cf5d16be5b97a22a",
	}

	-- Rainbow brackts
	use {
		"HiPhish/rainbow-delimiters.nvim"
	}

	use {
		"folke/noice.nvim",
		requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
	}
end)
