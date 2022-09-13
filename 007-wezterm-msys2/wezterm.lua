local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

--[[

local launch_msys2 = {
  label = "MSYS2",
  args = {"D:/Program/msys64/msys2_shell.cmd", "-defterm", "-here", "-no-start", "-msys"},
  cwd = "D:/msys64/home/" .. os.getenv('USERNAME'),
  domain = {DomainName="local"},
}
-- https://github.com/wez/wezterm/issues/2090
-- https://github.com/wez/wezterm/discussions/2093
-- https://wezfurlong.org/wezterm/config/launch.html

--]]

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- We are running on Windows; maybe we emit different
  -- key assignments here?
  msys2_work_dir = "d://Program/msys64/"
end



return {
  default_prog = { "D:/Program/msys64/msys2_shell.cmd", "-defterm", "-where", msys2_work_dir, "-no-start", "-msys" },
  -- appearance
  window_frame = {
    -- The font used in the tab bar.
    -- Roboto Bold is the default; this font is bundled
    -- with wezterm.
    -- Whatever font is selected here, it will have the
    -- main font setting appended to it to pick up any
    -- fallback fonts you may have used there.

    -- TAB BAR FONT!!
    font = wezterm.font_with_fallback {
      {
        family = 'FiraCode NFM',
        weight = 'DemiBold',
        -- family = 'JetBrainsMono NFM',
        -- weight = 'Bold',
        harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
      },
      {
        -- family = 'Noto Sans Mono CJK SC',
        family = 'Sarasa Mono SC',
        weight = 'Bold',
        harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
      },
    },

    -- The size of the font in the tab bar.
    -- Default to 10. on Windows but 12.0 on other systems
    font_size = 12.0,

    -- The overall background color of the tab bar when
    -- the window is focused
    active_titlebar_bg = '#333333',

    -- The overall background color of the tab bar when
    -- the window is not focused
    inactive_titlebar_bg = '#333333',
  },
  tab_max_width=560,
  window_background_opacity=0.9,
  text_background_opacity = 1.0,

  -- color config
  colors = {
    foreground = '#f0d0d0',
    background = '#1e2223',
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
    indexed = { [136] = '#af8700' },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',

    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#000000' },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

    quick_select_label_bg = { Color = 'peru' },
    quick_select_label_fg = { Color = '#ffffff' },
    quick_select_match_bg = { AnsiColor = 'Navy' },
    quick_select_match_fg = { Color = '#ffffff' },
    
  },

  -- font config
  -- Test ligature
  -- --- +++ -> <- >= <= != /= && !! ... .. ~> => >> ?.
  font = wezterm.font_with_fallback {
    {
      family = 'FiraCode NFM',
      weight = 'DemiBold',
      -- family = 'JetBrainsMonoNL NFM',
      -- weight = 'Bold',
      -- italic = true,
      harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
    },
    {
      -- family = 'Noto Sans Mono CJK SC',
      family = 'Sarasa Mono SC',
      weight = 'Bold',
      harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
    },
  },

  -- key binding
  keys = {
    { key = '1', mods = 'ALT', action = act.ActivateTab(0), },
    { key = '2', mods = 'ALT', action = act.ActivateTab(1), },
    { key = '3', mods = 'ALT', action = act.ActivateTab(2), },
    { key = '4', mods = 'ALT', action = act.ActivateTab(3), },
    { key = '5', mods = 'ALT', action = act.ActivateTab(4), },
    { key = '6', mods = 'ALT', action = act.ActivateTab(5), },
    { key = '7', mods = 'ALT', action = act.ActivateTab(6), },
    { key = '8', mods = 'ALT', action = act.ActivateTab(7), },
    { key = '9', mods = 'ALT', action = act.ActivateTab(8), },
    { key = 'w', mods = 'CTRL|ALT', action = act.CloseCurrentTab { confirm = true }, },
    { key = 'LeftArrow', mods = 'SHIFT', action = act.ActivateTabRelative(-1), },
    { key = 'RightArrow', mods = 'SHIFT', action = act.ActivateTabRelative(1), },
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1), },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1), },
    { key = 'w', mods = 'CTRL', action = act.CloseCurrentPane { confirm = true }, }, 
    { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = '\\', mods = 'CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
    { key = '1', mods = 'CTRL', action = act.PaneSelect { alphabet = '1234567890' }, },
    { key = '2', mods = 'CTRL', action = act.PaneSelect { alphabet = '1234567890' }, },
    { key = '3', mods = 'CTRL', action = act.PaneSelect { alphabet = '1234567890' }, },
    { key = '4', mods = 'CTRL', action = act.PaneSelect { alphabet = '1234567890' }, },
    { key = '5', mods = 'CTRL', action = act.PaneSelect { alphabet = '1234567890' }, },
    { key = '0', mods = 'CTRL', action = act.PaneSelect { mode = 'SwapWithActive' }, },
  },
   launch_menu = {
    {
	  args = {'ls'}
	},
  },
}

