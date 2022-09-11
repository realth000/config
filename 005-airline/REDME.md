## Airline
Light-weight powerline for vim.

## Install
1. Download vim plugin manager vim-plug at https://github.com/junegunn/vim-plug
   ~~~ bash
       curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ~~~
2. Download Airline and AirlineTheme:
   * https://github.com/vim-airline/vim-airline
   * https://github.com/vim-airline/vim-airline-themes
   Just git clone the repos above into ~/.vim/plugged, if no such directory, create it.
3. Copy the configs in vimrc to your ~/.vimrc

## Q
These configs were tested with Windows Terminal + MSYS 2 + zsh + oh-my-zsh.
Having good unix-shell experience on Windows 10.
Even faster login speed then the original MSYS 2 if using oh-my-zsh.
And better rendering: the original MSYS 2 has worse font redering and no statusline background.
