#!/bin/bash

dir="$HOME/.config/rofi"
theme='style-10'

option=$(printf "hyprland\nwaybar\ndotfiles\nswaync\nrofi\nkitty\nzsh\nstarship\nfastfetch" \
    | rofi -dmenu -p "Edit Config" -theme ${dir}/${theme}.rasi)

case "$option" in
    "hyprland") codium "$HOME/.config/hypr" ;;
    "waybar") codium "$HOME/.config/waybar" ;;
    "dotfiles") codium "$HOME/dotfiles";;
    "swaync") codium "$HOME/.config/swaync" ;;
    "rofi") codium "$HOME/.config/rofi" ;;
    "kitty") codium "$HOME/.config/kitty" ;;
    "zsh") codium "$HOME/.zshrc" ;;
    "starship") codium "$HOME/.config/starship.toml";;
    "fastfetch") codium "$HOME/.config/fastfetch/config.jsonc";;
esac