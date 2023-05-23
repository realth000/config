return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Color scheme
  use { 
    'navarasu/onedark.nvim'
  }
  require('plugins_config.onedark')

  use {
    'ellisonleao/gruvbox.nvim'
  }
  require('plugins_config.gruvbox')

  use {
    'projekt0n/github-nvim-theme'
  }
  require('plugins_config.github-nvim-theme')
  
  use {
    'folke/tokyonight.nvim'
  }
  require('plugins_config.tokyonight')
  
  use {
    'EdenEast/nightfox.nvim'
  }
  require('plugins_config.nightfox')

  use { "catppuccin/nvim", as = "catppuccin" }
  require('plugins_config.catppuccin')

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }
  require('plugins_config.nvim-tree')
  
  -- airline, recommand to use lualine in neovim.
  -- use {
  --   'vim-airline/vim-airline',
  --   'vim-airline/vim-airline-themes'
  -- }
  -- require('plugins_config.vim-airline')
  
  -- lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true,
    }
  }
  require('plugins_config.lualine')

  -- treesitter, hightlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
    -- Run after first install:
    -- :TSInstall cmake cpp dart diff gitcommit go python toml yaml vim
  }
  require('plugins_config.nvim-treesitter')

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
  require('plugins_config.mason')
  require('plugins_config.lspconfig')

  -- Auto complete brackts
  use {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup(); end
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  require('plugins_config.telescope')

  -- GitSigns
  use {
    'lewis6991/gitsigns.nvim',
    -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  }
  require('plugins_config.gitsigns')

  use {
    'vala-lang/vala.vim',
  }

end)
