local env_no_lsp = os.getenv("NVIM_NO_LSP")
if env_no_lsp then return end

local plugin = vim.lsp.config
if plugin == nil then return end

local setup_lang = function(lang, config)
	-- Use nvim provided api.
	vim.lsp.enable(lang, config)
	vim.lsp.config(lang, config)
end

-- Setting borders for lsp is discouraged, use the global `vim.o.winborder` config instead.
local float_window_border = {
	{ '╭', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╮', 'FloatBorder' },
	{ '│', 'FloatBorder' },
	{ '╯', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╰', 'FloatBorder' },
	{ '│', 'FloatBorder' },
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
-- The floating window border styles here are managed by noice.nvim.
-- But keep the config here for envs without noice.nvim.
--
-- Note that the default shortcut for vim.lsp.buf.hover is already Shift+K, so we do not need to specify it again.
-- But keep it here as a reminder.
vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({
	-- border = float_window_border
}); end, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help {
	-- border = float_window_border
} end, bufopts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

-- Config fields ref to https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
vim.diagnostic.config({
	-- severity_sort = true,
	-- update_in_insert = false,
	--
	-- Setting borders for lsp is discouraged, use the global `vim.o.winborder` config instead.
	-- float = {
	-- 	border = float_window_border,
	-- 	winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
	-- },
	-- Enable inline diagnostic message by default. Why nvim disabled it.
	--
	-- Inline error message.
	virtual_text = true,

	-- Verbose inline error message. The mesage appears under the current line for showing verbose info.
	-- virtual_lines = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '⨯',
			[vim.diagnostic.severity.WARN] = '󰀪',
			[vim.diagnostic.severity.INFO] = 'ℹ',
			[vim.diagnostic.severity.HINT] = '󰌶',
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = 'Error',
			[vim.diagnostic.severity.WARN] = 'Warn',
			[vim.diagnostic.severity.INFO] = 'Info',
			[vim.diagnostic.severity.HINT] = 'Hint',
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = 'Error',
			[vim.diagnostic.severity.WARN] = 'Warn',
			[vim.diagnostic.severity.INFO] = 'Info',
			[vim.diagnostic.severity.HINT] = 'Hint',
		},
	},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
end

------------------------------------------------
-- Set up lsp servers.

setup_lang('pyright', {
	on_attach = on_attach,
})

-- setup_lang('ts_ls', {
-- 	on_attach = on_attach,
-- })

-- Use https://github.com/mrcjkb/rustaceanvim instead
setup_lang('rust_analyzer', {
	on_attach = on_attach,
	-- Server-specific settings...
	settings = {
		['rust-analyzer'] = {
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
})

setup_lang('clangd', {
	cmd = {
		'clangd',
		'--clang-tidy',
		'--function-arg-placeholders=false', -- Disable clangd completion function parameters.
		-- '--fallback-style=None',       -- Set default format style to Google if no .clang-format found.
		'--header-insertion=never',
	},
	on_attach = on_attach,
	filetypes = {
		'c',
		'cpp',
	},
})

setup_lang('gopls', {
	on_attach = on_attach,
})

setup_lang('cmake', {
	on_attach = on_attach,
})

setup_lang('dartls', {
	on_attach = on_attach,
})

setup_lang('marksman', {
	on_attach = on_attach,
})

setup_lang('bashls', {
	on_attach = on_attach,
})

setup_lang('hls', {
	on_attach = on_attach,
	settings = {
		haskell = {
			cabalFormattingProvider = "cabal-fmt",
			formattingProvider = "fourmolu",
		}
	}
})

-- setup_lang('vala_ls', {
-- 	on_attach = on_attach,
-- })

setup_lang('zls', {
	on_attach = on_attach,
})

-- setup_lang('lua_ls', {
-- 	on_attach = on_attach,
-- 	settings = {
-- 		Lua = {
-- 			diagnostics = {
-- 				-- Get the language server to recognize the `vim` global
-- 				globals = {
-- 					'vim',
-- 					'require',
-- 				},
-- 			},
-- 			workspace = {
-- 				-- Make the server aware of Neovim runtime files
-- 				library = vim.api.nvim_get_runtime_file('', true),
-- 				checkThirdParty = false,
-- 			},
-- 			-- Do not send telemetry data containing a randomized but unique identifier
-- 			telemetry = {
-- 				enable = false,
-- 			},
-- 		},
-- 	},
-- })

setup_lang('nushell', {
	on_attach = on_attach,
})

-- setup_lang('biome', {
-- 	on_attach = on_attach,
-- })

setup_lang('gleam', {
	on_attach = on_attach,
})

-- setup_lang('csharp_ls', {
-- 	on_attach = on_attach,
-- })

setup_lang('jsonls', {
	on_attach = on_attach,
})

setup_lang('yamlls', {
	on_attach = on_attach,
})

-- setup_lang('kotlin_language_server', {
-- 	on_attach = on_attach,
-- })

setup_lang('perlnavigator', {
	on_attach = on_attach,
})

setup_lang('ruff', {
	on_attach = on_attach,
})

setup_lang('cssls', {
	on_attach = on_attach,
})

setup_lang('ocamllsp', {
	on_attach = on_attach,
})

setup_lang('ts_ls', {
	on_attach = on_attach,
})

setup_lang('tailwindcss', {
	on_attach = on_attach,
})
