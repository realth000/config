" The nushell config is here because neovim/runtime/indent/nu.vim
" is doing BAD THINGS like setting the indent to 2 spaces.
"
" We have to use `after/indent/nu.vim` to override it.
setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4
