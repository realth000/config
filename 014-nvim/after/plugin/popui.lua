local status, _ = pcall(require, 'popui')
if (not status) then return end

vim.ui.select = require('popui.ui-overrider')
vim.ui.input = require('popui.input-overrider')

vim.api.nvim_set_keymap('n', ',d', ':lua require"popui.diagnostics-navigator"()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',m', ':lua require"popui.marks-manager"()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',r', ':lua require"popui.references-navigator"()<CR>', { noremap = true, silent = true })

-- " Available styles: "sharp" | "rounded" | "double"
vim.g.popui_border_style = 'rounded'
