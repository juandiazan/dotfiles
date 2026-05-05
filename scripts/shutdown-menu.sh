#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "Lock\nLog out\nSuspend\nReboot\nShutdown" \
    | rofi -dmenu -p "Shutdown menu" -theme ${dir}/${theme}.rasi)

case "$option" in
    "Lock") pidof hyprlock || hyprlock & ;;
    "Log out") command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit ;;
    "Suspend") systemctl suspend ;;
    "Reboot")  systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
esac