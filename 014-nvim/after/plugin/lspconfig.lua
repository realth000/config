local env_no_lsp = os.getenv('NVIM_NO_LSP')
if env_no_lsp then return end

local setup_lang = function (lang, config)
	-- Use nvim provided api.
	vim.lsp.enable(lang, config)
	vim.lsp.config(lang, config)
end

--- The callback function when jump to to diagnostic.
---@param diag  vim.Diagnostic?
---@param bufnr integer
local function on_diag_jump(diag, bufnr)
	if not diag then
		return
	end

	-- Copied from `goto_diagnostic` in `runtime/lua/vim/diagnostic.lua`.
	vim.diagnostic.open_float({
		bufnr = bufnr,
		namespace = diag.namespace,
		scope = 'cursor',
		focus = false,
	})
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function ()
	vim.diagnostic.jump({ count = -1, on_jump = on_diag_jump })
end)
vim.keymap.set('n', ']d', function ()
	vim.diagnostic.jump({ count = 1, on_jump = on_diag_jump })
end)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
-- The floating window border styles here are managed by noice.nvim.
-- But keep the config here for envs without noice.nvim.
--
-- Note that the default shortcut for vim.lsp.buf.hover is already Shift+K, so we do not need to specify it again.
-- But keep it here as a reminder.
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
vim.keymap.set('n', '<space>wl', function ()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<space>f', function ()
	vim.lsp.buf.format({ async = true })
end)

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
local on_attach = function (_client, _bufnr)
end

------------------------------------------------
-- Set up lsp servers.

setup_lang('pyright', {
	on_attach = on_attach,
})

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
				enable = true,
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
			cabalFormattingProvider = 'cabal-fmt',
			formattingProvider = 'fourmolu',
		},
	},
})

setup_lang('zls', {
	on_attach = on_attach,
})

setup_lang('emmylua_ls', {
	on_attach = on_attach,

	cmd = { 'emmylua_ls' },
	filetypes = { 'lua' },
	root_markers = { '.emmyrc.lua', '.emmyrc.json', '.luarc.json', '.git' },
})

setup_lang('nushell', {
	on_attach = on_attach,
})

setup_lang('jsonls', {
	on_attach = on_attach,
})

setup_lang('yamlls', {
	on_attach = on_attach,
})

setup_lang('ruff', {
	on_attach = on_attach,
})

setup_lang('ocamllsp', {
	on_attach = on_attach,
})
