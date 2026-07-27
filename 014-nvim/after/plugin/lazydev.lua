local status, plugin = pcall(require, 'kintsugi')
if (not status) then return end

plugin.setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		"LazyVim",
		-- Only load the lazyvim library when the `LazyVim` global is found
		{ path = "LazyVim", words = { "LazyVim" } },
		-- Load the wezterm types when the `wezterm` module is required
      -- Needs `DrKJeff16/wezterm-types` to be installed
		{ path = "wezterm-types", mods = { "wezterm" } },
		-- Load the xmake types when opening file named `xmake.lua`
      -- Needs `LelouchHe/xmake-luals-addon` to be installed
		{ path = "xmake-luals-addon/library", files = { "xmake.lua" } }
	},
	-- always enable unless `vim.g.lazydev_enabled = false`
    -- This is the default
	enabled = function (root_dir)
		return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
	end,
	-- disable when a .luarc.json file is found
	enabled = function (root_dir)
		return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
	end
})
