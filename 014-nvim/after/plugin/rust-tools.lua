local status, plugin = pcall(require, 'rust-tools')
if (not status) then return end

-- The following on_attach comes from lspconfig.lua.
-- Use this to ensure when pressing Shift + K, man command is not called (otherwise will stuck).
-- Beside this config also gives compatibility to rust-tools with configs in lspconfig.
-- Refer: https://github.com/simrat39/rust-tools.nvim/issues/328#issuecomment-1470484544
--
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

	local signs = { Error = '⨯', Warn = '⚠', Hint = '󰌶', Info = '󰌶' }
	for type, icon in pairs(signs) do
		local hl = 'DiagnosticSign' .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

plugin.setup({
	tools = {
		runnables = {
			use_telescope = true,
		},

		-- inlay_hints = {
		--   auto = true,
		--   show_parameter_hints = false,
		--   parameter_hints_prefix = '',
		--   other_hints_prefix = '',
		-- },

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {
			-- automatically set inlay hints (type hints)
			-- default: true
			auto = true,

			-- Only show inlay hints for the current line
			only_current_line = true,

			-- whether to show parameter hints with the inlay hints or not
			-- default: true
			show_parameter_hints = true,

			-- prefix for parameter hints
			-- default: '<-'
			parameter_hints_prefix = '<- ',

			-- prefix for all the other hints (type, chaining)
			-- default: '=>'
			other_hints_prefix = '=> ',

			-- whether to align to the length of the longest line in the file
			max_len_align = false,

			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,

			-- whether to align to the extreme right or not
			right_align = false,

			-- padding from the right if right_align is true
			right_align_padding = 7,

			-- The color of the hints
			highlight = 'Comment',
		},

		-- options same as lsp hover / vim.lsp.util.open_floating_preview()
		hover_actions = {
			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = {
				{ '╭', 'FloatBorder' },
				{ '─', 'FloatBorder' },
				{ '╮', 'FloatBorder' },
				{ '│', 'FloatBorder' },
				{ '╯', 'FloatBorder' },
				{ '─', 'FloatBorder' },
				{ '╰', 'FloatBorder' },
				{ '│', 'FloatBorder' },
			},

			-- Maximal width of the hover window. Nil means no max.
			max_width = nil,

			-- Maximal height of the hover window. Nil means no max.
			max_height = nil,

			-- whether the hover action window gets automatically focused
			-- default: false
			auto_focus = false,
		},

		-- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
		reload_workspace_from_cargo_toml = true,
	},

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer

	server = {
		-- on_attach is a callback called when the language server attachs to the buffer
		on_attach = on_attach,
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			['rust-analyzer'] = {
				-- enable clippy on save
				checkOnSave = {
					command = 'clippy',
				},
				completion = {
					addCallParenthesis = true,
					addCallArgumentSnippets = false,
				},
				imports = {
					granularity = {
						group = 'module',
					},
					prefix = 'self',
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true
				},
			},
		},
	},
})
