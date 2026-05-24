#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "hyprland\nwaybar\ndotfiles\nswaync\nrofi\nkitty\nzsh\nstarship\nfastfetch" |
    rofi -dmenu -p "Edit Config" -theme ${dir}/${theme}.rasi)

case "$option" in
"hyprland") kitty -e nvim "$HOME/.config/hypr" ;;
"waybar") kitty -e nvim "$HOME/.config/waybar" ;;
"dotfiles") kitty -e nvim "$HOME/dotfiles" ;;
"swaync") kitty -e nvim "$HOME/.config/swaync" ;;
"rofi") kitty -e nvim "$HOME/.config/rofi" ;;
"kitty") kitty -e nvim "$HOME/.config/kitty" ;;
"zsh") kitty -e nvim "$HOME/.zshrc" ;;
"starship") kitty -e nvim "$HOME/.config/starship.toml" ;;
"fastfetch") kitty -e nvim "$HOME/.config/fastfetch/config.jsonc" ;;
esac
