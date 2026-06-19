#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

projects_dir="$HOME/Projects"

projects=$(find "$projects_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [ -z "$projects" ]; then
    notify-send "Projects" "No projects found in $projects_dir"
    exit 0
fi

option=$(printf '%s\n' "$projects" |
    rofi -dmenu -p "Open project" -theme "${dir}/${theme}.rasi")

[ -z "$option" ] && exit 0

kitty -e nvim "$projects_dir/$option"
