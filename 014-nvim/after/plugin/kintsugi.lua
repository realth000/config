local status, _p = pcall(require, 'kintsugi')
if (not status) then return end

---@module 'kintsugi'
local plugin = _p

local config = {
	---@type 'dark' | 'flared'
	variant = 'flared',
	transparent = GetThemeUseTransparent(),
	terminal_colors = true,
	bold_keywords = true,
	italic_comments = false,
}

plugin.setup(config)
