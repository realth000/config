-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
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

  local signs = { Error = "⨯", Warn = "⚠", Hint = "󰌶", Info = "󰌶"}
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

------------------------------------------------
-- Set up lsp servers.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
	capabilities = capabilities,
}
-- require('lspconfig')['tsserver'].setup{
--     on_attach = on_attach,
--     flags = lsp_flags,
-- }
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {
	    completion = {
		  addCallParenthesis = true,
		  addCallArgumentSnippets = false,
		},
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
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
}
require('lspconfig')['clangd'].setup{
	cmd = {
	  "clangd",
	  "--clang-tidy",
	  "--function-arg-placeholders=false", -- Disable clangd completion function parameters.
	},
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = {
    "c",
    "cpp",
  },
  single_file_support = true,
	capabilities = capabilities,
}
require('lspconfig')['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    single_file_support = true,
	capabilities = capabilities,
}
require('lspconfig')['cmake'].setup{
    on_attach = on_attach,
    single_file_support = true,
	capabilities = capabilities,
}
-- require('lspconfig')['dartls'].setup{
-- 	on_attach = on_attach,
--     flags = lsp_flags,
-- 	single_file_support = true,
-- capabilities = capabilities,
-- }
require('lspconfig')['marksman'].setup{
    on_attach = on_attach,
    single_file_support = true,
	capabilities = capabilities,
}
require('lspconfig')['bashls'].setup{
	on_attach = on_attach,
	single_file_support = true,
	capabilities = capabilities,
}
require('lspconfig')['vala_ls'].setup{
	on_attach = on_attach,
	single_file_support = true,
    capabilities = capabilities,
}
