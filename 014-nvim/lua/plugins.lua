return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Color scheme
  use { 
    'navarasu/onedark.nvim'
  }
  require('plugins_config.onedark')

  use {
    'projekt0n/github-nvim-theme'
  }
  require('plugins_config.github-nvim-theme')

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
  }
  require('plugins_config.mason')
  require('plugins_config.lspconfig')
end)
