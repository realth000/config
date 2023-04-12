vim.opt.nu = true
vim.opt.rnu = true
vim.opt.hls = true
vim.opt.incsearch = true
vim.opt.ruler = true
-- Always use system clipboard,
-- see Clipboard integration in https://neovim.io/doc/user/provider.html
-- Need to install clipboard tool.
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = ''
vim.opt.autoindent= true
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- vim.opt.list = true
vim.opt.listchars = 'tab:-->'
-- ↵    ↲  

-- Neovide settings.
if vim.g.neovide then
  --测试中文
  vim.opt.guifont= { "Iosevka1204Extended NF,Sarasa Mono SC:h13:"}
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_hide_mouse_when_typing = true 
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  -- vim.g.neovide_underline_automatic_scaling = true
  vim.g.neovide_remember_window_size = false
end

vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeToggle<CR>')

-- Auto formatting when save file.
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- Format and save command.
vim.cmd [[command FW :lua vim.lsp.buf.formatting_sync(); vim.cmd('w')]]

--vim.api.nvim_set_keymap("n", "<leader>i", ":lua vim.diagnostic.open_float(nil, {focus=false, scope='cursor'})<CR>", default_opts)
--vim.keymap.set('n', '<leader>i', ':lua vim.diagnostic.open_float(nil, {focus=true, scope="cursor"})<CR>')
vim.keymap.set('n', '<leader>i', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
--lua vim.diagnostic.open_float(nil, {focus=false,scope="cursor"})
