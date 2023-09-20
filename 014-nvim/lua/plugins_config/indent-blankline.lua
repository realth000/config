vim.opt.termguicolors = true

-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.cmd [[highlight IndentBlankline1 guifg=#483f25 gui=nocombine]]
vim.cmd [[highlight IndentBlankline2 guifg=#2b3c2b gui=nocombine]]
vim.cmd [[highlight IndentBlankline3 guifg=#253a4b gui=nocombine]]
vim.cmd [[highlight IndentBlankline4 guifg=#30435a gui=nocombine]]
vim.cmd [[highlight IndentBlankline5 guifg=#1f3735 gui=nocombine]]


-- vim.cmd [[highlight IndentBlanklineBackgroundIndent1 guibg=#1f1f1f gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineBackgroundIndent2 guibg=#1a1a1a gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlankline1",
        "IndentBlankline2",
        "IndentBlankline3",
        "IndentBlankline4",
        "IndentBlankline5",
    },
}
