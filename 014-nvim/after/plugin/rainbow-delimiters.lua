local status, _p = pcall(require, 'rainbow-delimiters')
if (not status) then return end

---@module 'rainbow-delimiters'
local plugin = _p

vim.cmd([[highlight RainbowDelimiter1 guifg=#e8ba36 gui=nocombine]])
vim.cmd([[highlight RainbowDelimiter2 guifg=#54a857 gui=nocombine]])
vim.cmd([[highlight RainbowDelimiter3 guifg=#359ff4 gui=nocombine]])
vim.cmd([[highlight RainbowDelimiter4 guifg=#6e7dd9 gui=nocombine]])
vim.cmd([[highlight RainbowDelimiter5 guifg=#179387 gui=nocombine]])
-- vim.cmd([[highlight RainbowDelimiter1 guifg=#483f25 gui=nocombine]])
-- vim.cmd([[highlight RainbowDelimiter2 guifg=#2b3c2b gui=nocombine]])
-- vim.cmd([[highlight RainbowDelimiter3 guifg=#253a4b gui=nocombine]])
-- vim.cmd([[highlight RainbowDelimiter4 guifg=#30435a gui=nocombine]])
-- vim.cmd([[highlight RainbowDelimiter5 guifg=#1f3735 gui=nocombine]])

vim.g.rainbow_delimiters = {
	strategy = {
		[''] = plugin.strategy['global'],
		vim = plugin.strategy['local'],
	},
	query = {
		[''] = 'rainbow-delimiters',
		lua = 'rainbow-blocks',
	},
	-- highlight = {
	--     'RainbowDelimiterRed',
	--     'RainbowDelimiterYellow',
	--     'RainbowDelimiterBlue',
	--     'RainbowDelimiterOrange',
	--     'RainbowDelimiterGreen',
	--     'RainbowDelimiterViolet',
	--     'RainbowDelimiterCyan',
	-- },
	highlight = {
		'RainbowDelimiter1',
		'RainbowDelimiter2',
		'RainbowDelimiter3',
		'RainbowDelimiter4',
		'RainbowDelimiter5',
	},
}
