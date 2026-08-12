#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "hyprland\nwaybar\ndotfiles\nswaync\nrofi\nkitty\nzsh\nstarship\nfastfetch\nags" |
    rofi -dmenu -p "Edit Config" -theme ${dir}/${theme}.rasi)

[ -z "$option" ] && exit 0

case "$option" in
"hyprland") target="$HOME/.config/hypr" ;;
"waybar") target="$HOME/.config/waybar" ;;
"dotfiles") target="$HOME/dotfiles" ;;
"swaync") target="$HOME/.config/swaync" ;;
"rofi") target="$HOME/.config/rofi" ;;
"kitty") target="$HOME/.config/kitty" ;;
"zsh") target="$HOME/.zshrc" ;;
"starship") target="$HOME/.config/starship.toml" ;;
"fastfetch") target="$HOME/.config/fastfetch/config.jsonc" ;;
"ags") target="$HOME/.config/ags" ;;
*) exit 0 ;;
esac

if [ -d "$target" ]; then
    workdir="$target"
    nvim_cmd="nvim ."
else
    workdir="$(dirname "$target")"
    nvim_cmd="nvim \"$target\""
fi

if command -v tmux >/dev/null 2>&1; then
    exec kitty -e tmux new-session -As "$option" -c "$workdir" "$nvim_cmd"
else
    exec kitty -d "$workdir" -e nvim "$target"
fi
