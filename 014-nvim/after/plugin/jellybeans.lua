local status, plugin = pcall(require, 'jellybeans')
if (not status) then return end

plugin.setup({
  transparent = GetThemeUseTransparent(),
  italics = true,
  bold = true,
  flat_ui = true, -- toggles "flat UI" for pickers
  background = {
    dark = "jellybeans",       -- default dark palette
    light = "jellybeans_light", -- default light palette
  },
  plugins = {
    all = false,
    auto = true, -- auto-detect installed plugins via lazy.nvim
  },
  on_highlights = function(highlights, colors) end,
  on_colors = function(colors) end,
})
