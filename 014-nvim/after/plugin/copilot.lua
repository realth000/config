local status, plugin = pcall(require, 'copilot')
if (not status) then return end

plugin.setup({
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = '[[',
			jump_next = ']]',
			accept = '<CR>',
			refresh = 'gr',
			open = '<M-CR>'
		},
		layout = {
			position = 'bottom', -- | top | left | right
			ratio = 0.4
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 300,
		keymap = {
			accept = '<Tab>',
			accept_word = false,
			accept_line = false,
			-- next = '<C-]>',
			-- prev = '<C-[>',
			-- dismiss = '<C-]>',
		},
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		['.'] = false,
	},
	copilot_node_command = 'node', -- Node.js version must be > 16.x
	server_opts_overrides = {},
})
