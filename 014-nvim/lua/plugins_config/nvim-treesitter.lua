require('nvim-treesitter.configs').setup({
  ensure_installed = { "cmake", "cpp", "dart", "diff", "gitcommit", "go", "python", "toml", "yaml", "vim" },
  sync_install = false,
  auto_install = true,
  -- highlight = {
  --   enable = true,
  -- },
})
