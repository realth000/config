local status, plugin = pcall(require, 'gitsigns')
if (not status) then return end

plugin.setup {
	signs                        = {
		add          = { text = '┃' },
		change       = { text = '┃' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir                 = {
		interval = 1000,
		follow_files = true
	},
	attach_to_untracked          = true,
	current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts      = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 300,
		ignore_whitespace = false,
	},
	-- 「 」 『 』
	current_line_blame_formatter = '  『 <author> - <author_time:%Y-%m-%d> - <abbrev_sha> 』',
	sign_priority                = 6,
	update_debounce              = 300,
	status_formatter             = nil, -- Use default
	max_file_length              = 40000, -- Disable if file is longer than this (in lines)
	preview_config               = {
		-- Options passed to nvim_open_win
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
}

-- Set blame line text style, based on comment style.
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.cmd("highlight! link GitSignsCurrentLineBlame Comment")

		local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
		local fg_color = comment_hl.fg

		-- Remove all style: no italic/bold/underline
		if fg_color then
			vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
				fg = fg_color,
				underline = false,
				italic = false,
				bold = false,
				underdouble = false,
				sp = fg_color,
			})
		end
	end,
})
