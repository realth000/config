require('lualine').setup {
  options = {
    icons_enabled = true,
	-- See https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
	-- palenight moonfly code_dark gruvbox_material horizon material nightfly onedark
    -- powerline_dark solarized_dark jellybeans everforest gruvbox_dark iceberg_dark modus-vivendi wombat papercolor_dark
    theme = 'palenight',
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    -- component_separators = { left = '/', right = '/'},
    -- section_separators = { left = '', right = ''},
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
--     disabled_filetypes = {
--       statusline = {},
--       winbar = {},
--     },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    -- lualine_a = {'buffers'},
    -- lualine_b = {'branch'},
    -- lualine_c = {'filename'},
    -- lualine_x = {},
    -- lualine_y = {},
    -- lualine_z = {'tabs'}
  },
  winbar = {
    -- lualine_a = {},
    -- lualine_b = {},
    -- lualine_c = {'filename'},
    -- lualine_x = {},
    -- lualine_y = {},
    -- lualine_z = {}
  },
  inactive_winbar = {},
  extensions = {}
}
