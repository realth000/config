local status, plugin = pcall(require, 'kintsugi')
if (not status) then return end

plugin.setup({
	variant = "flared",        -- "dark" | "flared"
	transparent = GetThemeUseTransparent(),
	terminal_colors = true,
	bold_keywords = true,
	italic_comments = false,
})

