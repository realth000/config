local status, plugin = pcall(require, 'palenight')
if (not status) then return end

plugin.setup({
	-- Some terminals don't display italics very well,
	-- thus, they're disabled by default.
	italic = true,

	-- Fallback color palette for non-truecolor terminals,
	-- such as tty or some really old terminal.
	--
	-- Available options:
	-- "auto" => 16 color palette if in linux tty, 256 otherwise.
	-- 256    => 256 color palette.
	-- 16     => 16 color palette.
	cterm_palette = "auto",
})

