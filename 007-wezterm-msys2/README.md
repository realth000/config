## Wezterm + MSYS 2
Same experience on Windows and Linux, with powerful zsh and more plugins!

## Install
* Install Wezterm from official website.
* Install required fonts in the lua config file.
* Install MSYS 2 (if Windows).
* Install ZSH and other plugins in MSYS2 (Steps in 004-windows-terminal-msys2).

## Windows
1. Copy ``.wezterm.lua`` beside wezterm, rename to ``wezterm.lua``.

2. Configure the msys2 path in ``wezterm.lua``.

   - Set msys2 path at this line:

     ``` lua
     default_prog = { "D:/Program/msys64/msys2_shell.cmd", "-defterm", "-where", msys2_work_dir, "-no-start", "-msys" },
     ```

Links:
* https://wezfurlong.org/wezterm/config/launch.html
* https://github.com/wez/wezterm/discussions/2093
* https://github.com/wez/wezterm/issues/2090

## Linux
1. Copy ``.wezterm.lua`` to ``~/``.

## KDE Dolphin
* To use Wezterm as the default terminal, create a ``kdeglobals`` file in ``~/.config`` and add a key ``[General]``and sub key ``TerminalApplication`` with value ``start_wezterm``.
* Put ``start_wezterm`` in ``/usr/bin/``.
* ``start_wezterm`` comes from [here](https://github.com/wez/wezterm/blob/main/assets/open-wezterm-here).


