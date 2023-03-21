#!/bin/bash

ps -ef | grep /usr/bin/xborder | grep -v grep | tr -s ' ' | cut -d' ' -f2 | xargs sudo kill -9

xborder --config ~/.config/xborder/xborder.json

