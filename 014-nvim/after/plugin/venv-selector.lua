local status, plugin = pcall(require, 'venv-selector')
if (not status) then return end

plugin.setup({

})

vim.keymap.set('n', ',v', '<CMD>VenvSelect<CR>')
