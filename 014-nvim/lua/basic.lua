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
if vim.g.neovide then
	--测试中文
	vim.opt.guifont = { "Iosevka1204 Nerd Font Mono,Sarasa Mono SC:h13:" }
	vim.g.neovide_transparency = 0.95
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	-- vim.g.neovide_underline_automatic_scaling = true
	vim.g.neovide_remember_window_size = false
end


-- ci|
function my_function()
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
	local start_pos = math.max(0, cursor_row - 1)
	local end_pos = math.max(0, cursor_row)
	local buffer_rows = vim.api.nvim_buf_get_lines(0, start_pos, end_pos, false)
	local ret = ''
	local delete_start_pos
	local delete_end_pos

	local buffer_text = ''
	for _, v in ipairs(buffer_rows) do
		buffer_text = buffer_text .. v
	end

	local find_pos = 1
	while true do
		local x, y = string.find(buffer_text, '|', find_pos, true)
		if x == nil then break end
		if x <= cursor_col then
			delete_start_pos = y
		end
		if x > cursor_col and delete_end_pos == nil then
			delete_end_pos = y
		end

		if delete_start_pos ~= nil and delete_end_pos ~= nil then
			ret = buffer_text:sub(1, delete_start_pos) .. buffer_text:sub(delete_end_pos)
			vim.api.nvim_buf_set_lines(0, cursor_row, cursor_row, true, {ret})
			vim.cmd('delete')
			vim.cmd('startinsert')
			vim.api.nvim_win_set_cursor(0, {cursor_row, cursor_col - delete_start_pos + 1})
			print(ret)
			break
		end
		find_pos = y + 1
	end
end

vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', 'ci|', my_function)

-- Auto formatting when save file.
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- Format and save command.
vim.cmd [[command FW :lua vim.lsp.buf.format(); vim.cmd('w')]]
vim.cmd [[command SI :lua vim.cmd("IBLEnable"); vim.cmd("set list")]]
vim.cmd [[command NI :lua vim.cmd("IBLDisable"); vim.cmd("set nolist")]]

-- Cursor style

-- vim.opt.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.guicursor = "n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait100-blinkon400-blinkoff400"

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
