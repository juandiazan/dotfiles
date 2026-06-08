#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "waybar\nswaync\nwidgets (aylur's gtk shell)" \
    | rofi -dmenu -p "Restart service" -theme ${dir}/${theme}.rasi)

case "$option" in 
    "waybar") pkill waybar; waybar & ;;
    "swaync") swaync-client -R && swaync-client -rs ;;
    "widgets (aylur's gtk shell)") ags quit; ags run & ;;
esac