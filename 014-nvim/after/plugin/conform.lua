local status, plugin = pcall(require, 'conform')
if (not status) then return end

plugin.setup({
	formatters_by_ft = {
		-- haskell = { "fourmolu" },
	},
	-- Optional: Set up format-on-save
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = false,
	},
})
