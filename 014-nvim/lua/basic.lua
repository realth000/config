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
vim.opt.shiftwidth = 4
vim.opt.list = true
vim.opt.listchars = 'tab:-->'
-- ↵    ↲  

-- Neovide settings.
if vim.g.neovide then
  --测试中文
  vim.opt.guifont= { "Iosevka1204Extended NF,Sarasa Mono SC:h13:"}
  vim.g.neovide_transparency = 1
  vim.g.neovide_hide_mouse_when_typing = true 
end

vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeToggle<CR>')

