#!/bin/bash

# This file should be placed at $HOME/.local/share/config.sh to work properly.
# Symlink to the place you directly call it, like /usr/bin/config.

set -e

CMD="$0"
TARGET="$1"

print_help() {
	echo "usage:"
	echo "    $CMD nv|nvim       Edit nvim config"
	echo "    $CMD sh|zsh        Edit zshrc"
	echo "    $CMD wz|wezterm    Edit wezterm config"
	echo "    $CMD it|config     Edit config.sh itself"
}

if [ -z "$TARGET" ]; then
	print_help
	exit 1
fi

case "$TARGET" in
nv|nvim)
	NVIM_NO_LSP=1 nvim "$HOME/.config/nvim"
	;;
sh|zsh)
	nvim "$HOME/.zshrc"
	;;
wz|wezterm)
	NVIM_NO_LSP=1 nvim "$HOME/.wezterm.lua"
	;;
it|config)
	NVIM_NO_LSP=1 nvim "$HOME/.local/share/config.sh"
	;;
-h | --help | help)
	print_help
	;;
*)
	printf "unknown target\n\n"
	print_help
	;;
esac
