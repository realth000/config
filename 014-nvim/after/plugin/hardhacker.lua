local status, plugin = pcall(require, 'hardhacker')
if (not status) then return end

vim.g.hardhacker_hide_tilde = 1
vim.g.hardhacker_keyword_italic = 1
