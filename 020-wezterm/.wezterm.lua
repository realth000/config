local wezterm                      = require 'wezterm'
local mux                          = wezterm.mux
local act                          = wezterm.action

-- customize color scheme
local custom_alabaster             = wezterm.color.get_builtin_schemes()['Alabaster']
local catppuccin_mocha             = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
local hardhacker                   = wezterm.color.get_builtin_schemes()['hardhacker']

-- customize oh-my-zsh suggestions plugin suggest text color to optimize ctrl + F.
custom_alabaster.brights[1]        = "#595f5f"
-- color_scheme = "midnight-in-mojave", -- ctrl + f
-- color_scheme = "Alabaster", -- ok
-- color_scheme = "CLRS", -- good
-- color_scheme = "Doom Peacock", -- ctrl + f
-- color_scheme = "Galizur", -- good
-- color_scheme = "GoogleDark (Gogh)", -- cursor
-- color_scheme = "Material", -- ok half ctrl + f
-- color_scheme = "MaterialDark", -- as above
-- color_scheme = "Solarized Darcula", -- ctrl + f

local custom_catppuccin_mocha      = wezterm.color.get_builtin_schemes()['Alabaster']
custom_catppuccin_mocha.ansi[1]    = "#45475a"
custom_catppuccin_mocha.brights[1] = "#585b70"
custom_catppuccin_mocha.ansi[2]    = "#f38ba8"
custom_catppuccin_mocha.brights[2] = "#f38ba8"
custom_catppuccin_mocha.ansi[3]    = "#a6e3a1"
custom_catppuccin_mocha.brights[4] = "#a6e3a1"
custom_catppuccin_mocha.ansi[4]    = "#f9e2af"
custom_catppuccin_mocha.brights[4] = "#f9e2af"
custom_catppuccin_mocha.ansi[5]    = "#89b4fa"
custom_catppuccin_mocha.brights[5] = "#89b4fa"
custom_catppuccin_mocha.ansi[6]    = "#f5c2e7"
custom_catppuccin_mocha.brights[6] = "#f5c2e7"
custom_catppuccin_mocha.ansi[7]    = "#94e2d5"
custom_catppuccin_mocha.brights[7] = "#94e2d5"
custom_catppuccin_mocha.ansi[8]    = "#bac2de"
custom_catppuccin_mocha.brights[8] = "#bac2de"

wezterm.on('gui-startup', function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window. If they didn't specify it, use a default empty SpawnCommand.
	local cmd = cmd or {}
	-- I prefer to use the cwd of the gui process instead of (probably) the home dir
	if not cmd.cwd then
		cmd.cwd = wezterm.procinfo.current_working_dir_for_pid(wezterm.procinfo.pid())
	end
	mux.spawn_window(cmd)
end)

local config = {}

config.front_end = "OpenGL"
-- Disable wayland to avoid cursor blink always stuck on wayland
config.enable_wayland = false

------------------------ Tab bar style ------------------------

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

config.tab_max_width = 30
-- config.max_width = 30
config.tab_bar_at_bottom = true
-- fancy bar management may be deprecated in future according to
-- https://github.com/wez/wezterm/issues/1180
config.use_fancy_tab_bar = false

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local title = tab_title(tab)
		-- local edge_background1 = '#0b0022'
		local edge_background1 = 'transparent'
		local edge_background2 = 'transparent'
		local edge_background3 = 'transparent'
		local edge_background4 = 'transparent'

		local background = '#1b1032'
		local foreground = '#808080'

		if tab.is_active then
			background = '#2b2042'
			-- foreground = '#c0c0c0'
			foreground = '#303030'
			edge_background1 = '#caa7f7'
			edge_background2 = '#9178b5'
			edge_background3 = '#665682'
			edge_background4 = '#3b3450'
		elseif hover then
			background = '#3b3052'
			foreground = '#909090'
		end

		-- if tab.is_active then
		--   return {
		--     { Background = { Color = 'blue' } },
		--     { Text = ' ' .. title .. ' ' },
		--   }
		-- end

		local title = tab_title(tab)

		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = wezterm.truncate_right(title, max_width - 8)

		return {
			{ Background = { Color = edge_background4 } },
			{ Foreground = { Color = edge_background4 } },
			{ Text = ' ' },
			{ Background = { Color = edge_background3 } },
			{ Foreground = { Color = edge_background3 } },
			{ Text = ' ' },
			{ Background = { Color = edge_background2 } },
			{ Foreground = { Color = edge_background2 } },
			{ Text = ' ' },
			-- { Background = { Color = edge_background1 } },
			-- { Foreground = { Color = edge_background1 } },
			-- { Text = ' ' },
			{ Background = { Color = edge_background1 } },
			{ Foreground = { Color = foreground } },
			{ Text = ' ' .. title .. ' ' },
			-- { Background = { Color = edge_background1 } },
			-- { Foreground = { Color = edge_background1 } },
			-- { Text = ' ' },
			{ Background = { Color = edge_background2 } },
			{ Foreground = { Color = edge_background2 } },
			{ Text = ' ' },
			{ Background = { Color = edge_background3 } },
			{ Foreground = { Color = edge_background3 } },
			{ Text = ' ' },
			{ Background = { Color = edge_background4 } },
			{ Foreground = { Color = edge_background4 } },
			{ Text = ' ' },
		}
	end
)

-- NOT check update
config.check_for_updates = false

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.

	-- TAB BAR FONT!! ->
	font = wezterm.font_with_fallback {
		{
			-- family = 'FiraCode NFM',
			-- weight = 'Medium',
			-- family = 'JetBrainsMono NFM',
			-- weight = 'Bold',
			family = 'Iosevka1204 Nerd Font Mono',
			weight = 'DemiBold',
			harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
		},
		{
			-- family = 'Noto Sans Mono CJK SC',
			family = 'Sarasa Mono SC',
			-- family = 'Source Han Sans CN',
			weight = 'DemiBold',
			harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
		},
	},

	-- The size of the font in the tab bar.
	-- Default to 10. on Windows but 12.0 on other systems
	-- font_size = 14.0,

	-- inactive_titlebar_bg = '#ff0000',
	-- active_titlebar_bg = '#ff0000',
	-- inactive_titlebar_fg = '#11111B',
	-- active_titlebar_fg = '#ffffff',
	--
}

config.font_size = 13.0
config.show_new_tab_button_in_tab_bar = false
config.window_background_opacity = 0.92
config.text_background_opacity = 0.92
config.cursor_thickness = "200%"
-- This blink rate config will override all blink settings in other software
-- e.g. vim.opt.guicursor="n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait100-blinkon400-blinkoff400"
-- Blink always stuck when wayland enabled.
config.cursor_blink_rate = 500
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.color_schemes = {
	['custom_alabaster'] = custom_alabaster,
	['custom_catppuccin_mocha'] = custom_catppuccin_mocha,
	['catppuccin_mocha'] = catppuccin_mocha,
	['hardhacker'] = hardhacker,
}
config.color_scheme = 'custom_alabaster'
config.colors = {
	-- Old style
	-- foreground = '#f0d0d0',
	-- background = '#1e2223',
	-- cursor_bg = '#f1ffff',
	-- -- cursor_bg = 'transparent',
	-- -- cursor_bg = '#1e2223',
	-- cursor_fg = '#1e2223',
	-- cursor_border = '#f1ffff',
	-- selection_bg = '#2255cc',
	-- selection_fg = '#f1ffff',

	-- Catppuccin mocha style
	foreground = '#cdd6f4',
	background = '#1e1e2e',
	cursor_bg = '#f1ffff',
	cursor_bg = 'cdd6f4',
	cursor_fg = '#1e1e2e',
	cursor_border = '#cdd6f4',
	selection_bg = '#f5e0dc',
	selection_fg = '#1e1e2e',

	-- cursor_fg = '#f1ffff',
	-- cursor_border = '#52ad70',
	-- ansi = {
	--   'black',
	--   'maroon',
	--   'green',
	--   'olive',
	--   'red',
	--   'purple',
	--   'teal',
	--   'silver',
	-- },
	-- brights = {
	--   'grey',
	--   'red',
	--   'lime',
	--   'yellow',
	--   'blue',
	--   'fuchsia',
	--   'aqua',
	--   'white',
	-- },


	-- Arbitrary colors of the palette in the range from 16 to 255

	-- indexed = { [136] = '#af8700' },

	-- Since: 20220319-142410-0fcdea07
	-- When the IME, a dead key or a leader key are being processed and are effectively
	-- holding input pending the result of input composition, change the cursor
	-- to this color to give a visual cue about the compose state.

	-- compose_cursor = 'orange',

	-- Colors for copy_mode and quick_select
	-- available since: 20220807-113146-c2fee766
	-- In copy_mode, the color of the active text is:
	-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
	-- 2. selection_* otherwise

	-- copy_mode_active_highlight_bg = { Color = '#000000' },

	-- use `AnsiColor` to specify one of the ansi color palette values
	-- (index 0-15) using one of the names "Black", "Maroon", "Green",
	--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
	-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
	--
	-- copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
	-- copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
	-- copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

	-- quick_select_label_bg = { Color = 'peru' },
	-- quick_select_label_fg = { Color = '#ffffff' },
	-- quick_select_match_bg = { AnsiColor = 'Navy' },
	-- quick_select_match_fg = { Color = '#ffffff' },

	-- Tab bar. These configs only apply when use_fancy_tab_bar set to false.
	-- Retro Tab Bar appearance
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		-- background = '#0b0022',
		background = 'transparent',

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = '#2b2042',
			-- The color of the text for the tab
			fg_color = '#c0c0c0',

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = 'Normal',

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = 'None',

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = true,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = '#1b1032',
			fg_color = '#808080',

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = '#3b3052',
			fg_color = '#909090',
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab_hover`.
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = '#1b1032',
			fg_color = '#808080',

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = '#3b3052',
			fg_color = '#909090',
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	},
}

-- --- +++ -> <- >= <= != /= && !! ... .. ~> => >> ?.
config.font = wezterm.font_with_fallback {
	{
		-- family = 'FiraCode NFM',
		-- family = 'JetBrainsMono NFM',
		-- family = 'Iosevka0828 Nerd Font Mono Extended',
		family = 'Iosevka1204 Nerd Font Mono',
		-- family = 'CaskaydiaCove Nerd Font Mono',
		-- family = 'Hack Nerd Font Mono',
		-- family = 'IBM Plex Mono',
		-- weight = 'Medium',
		-- weight = 'Bold',
		weight = 'DemiBold',
		-- italic = true,
		harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
	},
	{
		-- family = 'Noto Sans Mono CJK SC',
		family = 'Sarasa Mono SC',
		-- family = 'Source Han Sans CN',
		-- 测试中文
		weight = 'DemiBold',
		harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
	},
}

config.keys = {
	{ key = '1',          mods = 'ALT',        action = act.ActivateTab(0), },
	{ key = '2',          mods = 'ALT',        action = act.ActivateTab(1), },
	{ key = '3',          mods = 'ALT',        action = act.ActivateTab(2), },
	{ key = '4',          mods = 'ALT',        action = act.ActivateTab(3), },
	{ key = '5',          mods = 'ALT',        action = act.ActivateTab(4), },
	{ key = '6',          mods = 'ALT',        action = act.ActivateTab(5), },
	{ key = '7',          mods = 'ALT',        action = act.ActivateTab(6), },
	{ key = '8',          mods = 'ALT',        action = act.ActivateTab(7), },
	{ key = '9',          mods = 'ALT',        action = act.ActivateTab(8), },
	{ key = '`',          mods = 'CTRL|ALT',   action = act.CloseCurrentTab { confirm = true }, },
	{ key = 'LeftArrow',  mods = 'SHIFT',      action = act.ActivateTabRelative(-1), },
	{ key = 'RightArrow', mods = 'SHIFT',      action = act.ActivateTabRelative(1), },
	{ key = 'PageUp',     mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1), },
	{ key = 'PageDown',   mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1), },
	{ key = '`',          mods = 'CTRL',       action = act.CloseCurrentPane { confirm = true }, },
	{ key = '|',          mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
	{ key = '\\',         mods = 'CTRL',       action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
	{ key = '1',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '2',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '3',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '4',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '5',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '6',          mods = 'CTRL',       action = act.PaneSelect { alphabet = '1234567890' }, },
	{ key = '0',          mods = 'CTRL',       action = act.PaneSelect { mode = 'SwapWithActive' }, },
	{ key = 'UpArrow',    mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1), },
	{ key = 'k',          mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1), },
	{ key = 'DownArrow',  mods = 'CTRL|SHIFT', action = act.ScrollByLine(1), },
	{ key = 'j',          mods = 'CTRL|SHIFT', action = act.ScrollByLine(1), },
	{
		key = ',',
		mods = 'CTRL',
		action = act.ActivateKeyTable {
			name = 'resize_pane',
			-- ont_shot = false,
			timeout_milliseconds = 1000,
		},
	},
}

config.key_tables = {
	resize_pane = {
		{ key = 'h', action = act.AdjustPaneSize { 'Left', 5 }, },
		{ key = 'j', action = act.AdjustPaneSize { 'Down', 5 }, },
		{ key = 'k', action = act.AdjustPaneSize { 'Up', 5 }, },
		{ key = 'l', action = act.AdjustPaneSize { 'Right', 5 }, },
	},
}

return config
