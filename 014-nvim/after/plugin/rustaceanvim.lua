local status, _ = pcall(require, 'rustaceanvim')
if (not status) then return end

vim.g.rustaceanvim = {
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
					extraEnv = {
						RUSTFLAGS = "--cfg rust_analyzer",
					},
				},
				procMacro = {
					enable = true
				},
			},
		},
	},

}
