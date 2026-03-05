#!/bin/bash

CONFIGS=(
    "zsh"
    "obsidian"
    "spicetify-theme"
    "hyprland-omarchy"
    "waybar"
)

declare -a SELECTED_CONFIGS=()

apply_configs() {
    while true; do
        clear
        show_config_selection_menu
        read -p "Choice: " choice

        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            index=$((choice-1))
            current_config="${CONFIGS[$index]}"
            if [[ " ${SELECTED_CONFIGS[*]} " == *" $current_config "* ]]; then
                remove_config_from_selected "$current_config"
            else
                SELECTED_CONFIGS+=("$current_config")
            fi
        elif [[ "$choice" == "a" ]]; then
            apply_selected_configs
            break
        elif [[ "$choice" == "q" ]]; then
            break
        else
            echo "Invalid option."
        fi
    done
}

remove_config_from_selected() {
    new_selected=()
    for item in "${SELECTED_CONFIGS[@]}"; do
        [[ "$item" != "$1" ]] && new_selected+=("$item")
    done
    SELECTED_CONFIGS=("${new_selected[@]}")
}

show_config_selection_menu() {
    echo "Select configurations to apply:"
    for i in "${!CONFIGS[@]}"; do
        current_config="${CONFIGS[$i]}"
        # Check if already selected
        if [[ " ${SELECTED_CONFIGS[*]} " == *" $current_config "* ]]; then
            mark="[x]"
        else
            mark="[ ]"
        fi
        printf "%2d) %s %s\n" $((i+1)) "$mark" "$current_config"
    done
    echo "a) Apply selected"
    echo "q) Quit"
}

apply_selected_configs(){
    echo "Applying selected configurations:"
    for config in "${SELECTED_CONFIGS[@]}"; do
        echo "Applying $config..."
        case $config in
            "zsh")
                cp ~/dotfiles/zsh-and-omz-config/.zshrc ~/
            ;;
            "obsidian")
                echo "TODO"
            ;;
            "spicetify-theme")
                echo "Applying spicetify theme..."
                spicetify config current_theme Sleek color_scheme Elementary
                spicetify apply
            ;;
            "hyprland-omarchy")
                echo "TODO"
            ;;
            "waybar")
                cp ~/dotfiles/waybar/* ~/.config/waybar/
            ;;
        esac
    done
    echo ""
}