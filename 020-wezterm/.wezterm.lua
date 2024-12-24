local wezterm                      = require 'wezterm'
local mux                          = wezterm.mux
local act                          = wezterm.action

-- customize color scheme
local catppuccin_mocha             = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
local hardhacker                   = wezterm.color.get_builtin_schemes()['hardhacker']

-- customize oh-my-zsh suggestions plugin suggest text color to optimize ctrl + F.
-- color_scheme = "midnight-in-mojave", -- ctrl + f
-- color_scheme = "Alabaster", -- ok
-- color_scheme = "CLRS", -- good
-- color_scheme = "Doom Peacock", -- ctrl + f
-- color_scheme = "Galizur", -- good
-- color_scheme = "GoogleDark (Gogh)", -- cursor
-- color_scheme = "Material", -- ok half ctrl + f
-- color_scheme = "MaterialDark", -- as above
-- color_scheme = "Solarized Darcula", -- ctrl + f

local custom_catppuccin_mocha      = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
-- black
custom_catppuccin_mocha.ansi[1]    = "#45475a"
custom_catppuccin_mocha.brights[1] = "#585b70"
-- red
custom_catppuccin_mocha.ansi[2]    = "#aa3731"
custom_catppuccin_mocha.brights[2] = "#f05050"
-- green
custom_catppuccin_mocha.ansi[3]    = "#448c27"
custom_catppuccin_mocha.brights[3] = "#60cb00"
-- yellow
custom_catppuccin_mocha.ansi[4]    = "#cb9000"
custom_catppuccin_mocha.brights[4] = "#ffbc5d"
-- blue
custom_catppuccin_mocha.ansi[5]    = "#325cc0"
custom_catppuccin_mocha.brights[5] = "#007acc"
-- magenta
custom_catppuccin_mocha.ansi[6]    = "#7a3e9d"
custom_catppuccin_mocha.brights[6] = "#e64ce6"
-- cyan
custom_catppuccin_mocha.ansi[7]    = "#0083b2"
custom_catppuccin_mocha.brights[7] = "#00aacb"
-- white
custom_catppuccin_mocha.ansi[8]    = "#bac2de"
custom_catppuccin_mocha.brights[8] = "#a6adc8"

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

-- Windows with MSYS2
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	-- config.default_prog = { 'D:/Program/msys64/msys2_shell.cmd', '-defterm', '-where', msys2_work_dir, '-no-start',
	local userprofile = os.getenv("USERPROFILE")
	config.default_prog = { string.format('%s/scoop/apps/nu/current/nu.exe', userprofile) }
end

-- config.front_end = "OpenGL"
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
	local start = string.find(tab_info.active_pane.title, '>')
	if start then
		return '[]' .. tab_info.tab_index + 1 .. ']' .. string.sub(tab_info.active_pane.title, start)
	else
		return '[' .. tab_info.tab_index + 1 .. '] ' .. tab_info.active_pane.title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local title = tab_title(tab)
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
			-- family = 'Iosevka1204 Nerd Font Mono',
			family = 'Iosevka1204 Nerd Font Mono Extended',
			weight = 'DemiBold',
			harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
		},
		{
			-- family = 'Noto Sans Mono CJK SC',
			family = 'Sarasa Mono SC',
			-- family = 'LXGW WenKai Mono GB',
			-- family = 'LXGW Neo XiHei',
			-- family = 'Source Han Sans CN',
			weight = 'DemiBold',
			harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
		},
		{
			family = 'SymbolsNerdFontMono',
		},
	},
}

config.font_size = 13.5
config.show_new_tab_button_in_tab_bar = false
config.window_background_opacity = 0.92
config.text_background_opacity = 0.92
config.cursor_thickness = "200%"
-- This blink rate config will override all blink settings in other software
-- e.g. vim.opt.guicursor="n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait100-blinkon400-blinkoff400"
-- Blink always stuck when wayland enabled.
config.cursor_blink_rate = 500
-- SteadyBlock BlinkingBlock SteadyUnderline BlinkingUnderline SteadyBar BlinkingBar
config.default_cursor_style = 'BlinkingBlock'
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.color_schemes = {
	['custom_catppuccin_mocha'] = custom_catppuccin_mocha,
	['catppuccin_mocha'] = catppuccin_mocha,
	['hardhacker'] = hardhacker,
}
config.color_scheme = 'custom_catppuccin_mocha'
config.colors = {
	-- selection_bg = '#f5e0dc',
	-- selection_fg = '#1e1e2e',

	-- Tab bar. These configs only apply when use_fancy_tab_bar set to false.
	-- Retro Tab Bar appearance
	tab_bar = {
		background = 'transparent',
	},
}

-- Preview:
--
-- --- +++ -> <- >= <= != /= && !! ... .. ~> => >> ?.
-- abcdefghijkLmnopqrstuvwxyz
-- ABCDEFGHIJKLMNOPQRSTUVWXYZ
-- 0123456789
--
-- ~ ! # $ % ^ & * ( ) - = _ + [ ] \ | ; ' : "
-- ` , . / < > ? { }
--
-- 测试中文
--
-- Fonts from Nerd Fonts:
--
-- CascadiaCode
-- CascadiaMono
-- CodeNewRoman
-- ComicShannsMono
-- FantasqueSansMono
-- FiraMono
-- GeistMono
-- Go-Mono
-- Hack
-- Hasklig
-- IntelOneMono
-- Iosevka1204_20240613
-- JetBrainsMono LXGWWenkai
-- LiberationMono
-- Lilex
-- MartianMono
-- Meslo
-- Mononoki
-- NerdFontsSymbolsOnly
-- Recursive
-- VictorMono
-- iA-Writer
-- roboto_mono
-- sarasa
-- source_code_pro
config.font = wezterm.font_with_fallback {
	{
		family = 'Iosevka1204 Nerd Font Mono Extended',
		-- family = 'ComicShannsMono Nerd Font Mono',
		-- family = 'CaskaydiaCove Nerd Font Mono',
		-- family = 'CodeNewRomanNerdFontMono',
		-- family = 'ComicShannsMonoNerdFontMono',
		-- family = 'FantasqueSansMNerdFontMono',
		-- family = 'FiraMonoNerdFont',
		-- family = 'GeistMonoNerdFont',
		-- family = 'GoMonoNerdFont',
		-- family = 'HackNerdFontMono',
		-- family = 'HasklugNerdFont',
		-- family = 'iMWritingMonoNerdFontMono',
		-- family = 'IntoneMonoNerdFontMono',
		-- family = 'JetBrainsMonoNerdFont',
		-- family = 'LiterationMonoNerdFontMono',
		-- family = 'LilexNerdFontMono',
		-- family = 'MartianMonoNerdFont',
		-- family = 'MesloLGLNerdFontMono',
		-- family = 'MesloLGMDZNerdFont',
		-- family = 'MononokiNerdFont',
		-- family = 'RecMonoCasualNerdFont',
		-- family = 'RecMonoSmCasualNerdFont', -- sm == smooth
		-- family = 'RecMonoLinear Nerd Font',
		-- family = 'RobotoMonoNerdFont',
		-- family = 'SauceCodeProNerdFontMono',
		-- family = 'VictorMonoNerdFontMono',
		-- weight = 'DemiBold',
		weight = 'Medium',
		harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
	},
	{
		-- family = 'Noto Sans Mono CJK SC',
		family = 'Sarasa Mono SC',
		-- family = 'LXGW WenKai Mono GB',
		-- family = 'lxgw neo xihei',
		-- family = 'Source Han Sans CN',
		-- 测试中文
		weight = 'DemiBold',
		harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
	},
	{
		family = 'SymbolsNerdFontMono',
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
