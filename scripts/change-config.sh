#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "Hyprland\nWaybar\nDotfiles\nSwayNC\nRofi\nKitty\nZsh\nStarship\nFastfetch" \
    | rofi -dmenu -p "Edit Config" -theme ${dir}/${theme}.rasi)

case "$option" in
    "Hyprland") codium "$HOME/.config/hypr" ;;
    "Waybar") codium "$HOME/.config/waybar" ;;
    "Dotfiles") codium "$HOME/dotfiles";;
    "SwayNC") codium "$HOME/.config/swaync" ;;
    "Rofi") codium "$HOME/.config/rofi" ;;
    "Kitty") codium "$HOME/.config/kitty" ;;
    "Zsh") codium "$HOME/.zshrc" ;;
    "Starship") codium "$HOME/.config/starship.toml";;
    "Fastfetch") codium "$HOME/.config/fastfetch/config.jsonc";;
esac