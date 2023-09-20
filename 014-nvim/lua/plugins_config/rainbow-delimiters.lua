-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.cmd [[highlight RainbowDelimiter1 guifg=#e8ba36 gui=nocombine]]
vim.cmd [[highlight RainbowDelimiter2 guifg=#54a857 gui=nocombine]]
vim.cmd [[highlight RainbowDelimiter3 guifg=#359ff4 gui=nocombine]]
vim.cmd [[highlight RainbowDelimiter4 guifg=#6e7dd9 gui=nocombine]]
vim.cmd [[highlight RainbowDelimiter5 guifg=#179387 gui=nocombine]]

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
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

