#!/bin/bash

THEME_DIR="/usr/share/themes"
ICON_DIR="/usr/share/icons"

if [ $# -lt 2 ];then
	echo "usage: $0 <theme name> <icon theme name>"
	echo "      Themes should in ${THEME_DIR}"
	echo "      Icons should in ${ICON_DIR}"
	exit
fi

THEME="$1"
ICON="$2"

THEME_PATH="${THEME_DIR}/${THEME}"
ICON_PATH="${ICON_DIR}/${ICON}"

if [ ! -d "${THEME_PATH}" ];then
	echo "Skip settings theme: ${THEME} not exists in ${THEME_DIR}" >&2
else
	gsettings set org.gnome.desktop.interface gtk-theme "${THEME}"
fi

if [ ! -d "${ICON_PATH}" ];then
	echo "Skip settings icon theme: ${ICON} not exists in ${ICON_DIR}" >&2
else
	gsettings set org.gnome.desktop.interface icon-theme "${ICON}"
fi


