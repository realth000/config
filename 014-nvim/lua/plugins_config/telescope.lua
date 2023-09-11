local builtin = require('telescope.builtin')
-- <leader> = '\\'
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fp', builtin.resume, {})

require('telescope').load_extension('aerial')

local extensions = require('telescope').extensions
vim.keymap.set('n', '<leader>fs', extensions.aerial.aerial, {})

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
	vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
	  '--sort=path',
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
		["<C-J>"] = "move_selection_next",
		["<C-k>"] = "move_selection_previous",
		["<C-b>"] = "results_scrolling_up",
		["<C-f>"] = "results_scrolling_down",
      }
    },
    -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
	shorten_path = true,
  },
  pickers = {
	-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#pickers
    -- find_files = {
	-- 	find_command = { "rg",  "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
	-- },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ['_'] = false, -- This key will be the default
        json = true,   -- You can set the option for specific filetypes
        yaml = true,
      }
    }
  },
}
