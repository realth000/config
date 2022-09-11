## windows-terminal-msys2
Use MSYS 2 in Windows Terminal will get exellent unix-shell experience on Windows.

## Config
In the file settings.json.

## Components
### MSYS 2
1. Download from [MSYS 2 Official Website](https://www.msys2.org/).
2. Use ``pacman -Syyu`` to update.
3. Install vim, zsh and oh-my-zsh via ``pacman``.

### ZSH and on-my-zsh
* Install the nl patched font. If the font not found in config page, just write the font name into the MSYS 2 config file, it also works.
  - Nerd fonts repo has some already patched fonts.
  - 因为是用Windows Terminal，默认的中文字体不是丑爆的宋体，不需要字体支持中文字符，仅仅打上nerd font就行。(没试过不知道是不是中文字符的宽度=两个英文，至少自己合并的fira code + meslo nf是1=2)
* MSYS 2 settings may need some change to apply zsh as default shell.
* Such as the ``set "LOGINSHELL=zsh"`` in msys2_shell.cmd.


### Windows Terminal
1. Download from Microsoft Store.
2. Open settings and import the content in settings.json.
#### Warning
* There may be some invalid configs since software install path differs.
* The only important config is ``D:\Program\msys64\msys2_shell.cmd -msys -defterm -no-start`` defterm and no-start args.
* Without importings configs in settings.json, keymap in Windows Terminal also need update to sync with linux terminals.

