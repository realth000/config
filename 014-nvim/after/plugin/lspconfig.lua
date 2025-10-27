local env_no_lsp = os.getenv("NVIM_NO_LSP")
if env_no_lsp then return end

local nvim_version = vim.version()
local setup_lang

if nvim_version.major == 0 and nvim_version.minor < 11 then
	-- nvim < 0.11.0
	local lsp_status, plugin = pcall(require, 'lspconfig')
	if (not lsp_status) then return end
	setup_lang = function(lang, config)
		-- Use legacy `require` method.
		plugin[lang].setup(config)
	end
else
	-- nvim >= 0.11.0
	local plugin = vim.lsp.config
	if plugin == nil then return end
	setup_lang = function(lang, config)
		-- Use nvim provided api.
		plugin[lang] = config
	end
end

local cmp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if (not cmp_status) then return end

-- Note that single file support is only needed to configure when
-- nvim is older than 0.11.0. Since 0.11.0, the `vim.lsp.config` API
-- enables single file support by default.
-- Remove this value when setup languages after we remove support for
-- nvim older than 0.11.0.
local single_file_support = true

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

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

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = float_window_border
	}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = float_window_border
	}
)

vim.diagnostic.config {
	float = {
		border = float_window_border
	}
}

------------------------------------------------
-- Set up lsp servers.

setup_lang('pyright', {
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

-- setup_lang('ts_ls', {
-- 	on_attach = on_attach,
-- 	flags = lsp_flags,
-- })

-- Use https://github.com/mrcjkb/rustaceanvim instead
setup_lang('rust_analyzer', {
	on_attach = on_attach,
	flags = lsp_flags,
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
	capabilities = capabilities,
})

setup_lang('clangd', {
	cmd = {
		'clangd',
		'--clang-tidy',
		'--function-arg-placeholders=false', -- Disable clangd completion function parameters.
		'--fallback-style=LLVM',       -- Set default format style to Google if no .clang-format found.
		'--header-insertion=never',
	},
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = {
		'c',
		'cpp',
	},
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('gopls', {
	on_attach = on_attach,
	flags = lsp_flags,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('cmake', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('dartls', {
	on_attach = on_attach,
	flags = lsp_flags,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('marksman', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('bashls', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('hls', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('vala_ls', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('zls', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

-- setup_lang('lua_ls', {
-- 	on_attach = on_attach,
-- 	single_file_support = single_file_support,
-- 	capabilities = capabilities,
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
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('biome', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('gleam', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('gleam', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})

setup_lang('csharp_ls', {
	on_attach = on_attach,
	single_file_support = single_file_support,
	capabilities = capabilities,
})
