vim.opt.nu = true
vim.opt.rnu = true
vim.opt.hls = true
vim.opt.incsearch = true
vim.opt.ruler = true
-- Always use system clipboard,
-- see Clipboard integration in https://neovim.io/doc/user/provider.html
-- Need to install clipboard tool. vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = ''
vim.opt.autoindent = true
-- vim.opt.cursorline = true
-- Ctrl + D/U scroll 10 lines each time
vim.opt.scroll = 10
vim.opt.scrolloff = 5
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.list = true
vim.o.background = 'dark'

-- Neovide settings.
-- if vim.g.neovide then
-- 	--测试中文
-- 	-- vim.opt.guifont = { "Iosevka1204 Nerd Font Mono,Sarasa Mono SC:h13:" }
-- 	vim.opt.guifont = { "Iosevka1204 Medium Extended,Sarasa Mono SC:h13:" }
-- 	vim.g.neovide_transparency = 0.95
-- 	vim.g.neovide_hide_mouse_when_typing = true
-- 	vim.g.neovide_floating_blur_amount_x = 2.0
-- 	vim.g.neovide_floating_blur_amount_y = 2.0
-- 	-- vim.g.neovide_underline_automatic_scaling = true
-- 	vim.g.neovide_remember_window_size = false
-- end

vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeToggle<CR>')

-- Content change keymap for other characters.
vim.keymap.set('n', 'di|', function() DeleteInsert('|') end)
vim.keymap.set('n', 'da|', function() DeleteAppend('|') end)
vim.keymap.set('n', 'ci|', function() ChangeInsert('|') end)
vim.keymap.set('n', 'ca|', function() ChangeAppend('|') end)

-- Auto formatting when save file.
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- Format and save command.
vim.cmd [[command FW :lua vim.lsp.buf.format(); vim.cmd('w')]]
vim.cmd [[command SI :lua vim.cmd("IBLEnable"); vim.cmd("set list")]]
vim.cmd [[command NI :lua vim.cmd("IBLDisable"); vim.cmd("set nolist")]]

-- Cursor style

-- vim.opt.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- vim.opt.guicursor = "n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait100-blinkon400-blinkoff400"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,i:ver25-blinkwait100-blinkon400-blinkoff400"

-- Restore scroll config after window resize
--
-- Events refer from:
-- https://stackoverflow.com/a/76897741
--
-- Autocmd usage refer from:
-- https://github.com/lewis6991/gitsigns.nvim/blob/d927caa075df63bf301d92f874efb72fd22fd3b4/lua/gitsigns.lua#L130
vim.api.nvim_create_autocmd({ 'VimResized', 'BufRead' }, {
	callback = function()
		vim.cmd [[set scroll=10]]
	end,
})
