#!/usr/bin/env bash

source ./utils/config-files.sh || {
    echo "Failed to load config file list."
    exit 1
}
source ./ui/menus.sh || {
    echo "Failed to load menu script."
    exit 1
}
source ./ui/colored_print.sh || {
    echo "Failed to load special print script."
    exit 1
}

declare -a SELECTED_CONFIGS=()

apply_configs() {
    while true; do
        clear
        show_config_selection_menu
        read -p "Choice: " choice

        case $choice in
            "a")
                apply_selected_configs
                break
            ;;
            "c")
                SELECTED_CONFIGS=()
            ;;
            "s")
                SELECTED_CONFIGS=("${CONFIGS[@]}")
            ;;
            "q")
                clear
                break
            ;;
            *)
                if [[ "$choice" =~ ^[1-9]+$ ]]; then
                    index=$((choice-1))
                    current_config="${CONFIGS[$index]}"
                    if [[ " ${SELECTED_CONFIGS[*]} " == *" $current_config "* ]]; then
                        remove_config_from_selected "$current_config"
                    else
                        SELECTED_CONFIGS+=("$current_config")
                    fi
                else
                    print_color $BOLD_RED "Invalid option. Press enter to continue."
                    read -p ""
                fi
            ;;
        esac
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
    config_actions_menu
}

apply_selected_configs(){
    echo "Applying selected configurations:"
    for config in "${SELECTED_CONFIGS[@]}"; do
        print_color $BOLD_PURPLE "=====> Applying $config..."
        case $config in
            "git credentials")
                echo "Enter your name"
                read name

                echo "Enter your email"
                read email

                git config --global user.name "$name"
                git config --global user.email "$email"
            ;;
            "zsh and omz config (.zshrc)")
                cp ~/dotfiles/zsh-and-omz-config/.zshrc ~/
                chsh -s "$(command -v zsh)"
                print_color $BOLD_YELLOW "=====> Log out and log back in, restart your terminal or run \"exec zsh\" for effects to apply."
            ;;
            "obsidian")
                echo "TODO"
            ;;
            "spicetify theme")
                echo "Applying spicetify theme..."
                spicetify config current_theme Sleek color_scheme Elementary
                spicetify apply
            ;;
            "omarchy hyprland files")
                echo "TODO"
            ;;
            "waybar hyprland files (jsonc and css)")
                cp ~/dotfiles/waybar/* ~/.config/waybar/
            ;;
            "browser bookmarks")
                echo "TODO"
            ;;
            "vs code settings and extensions")
                cp ~/dotfiles/vs-code-settings/settings.json ~/.config/Code/User/

                for extension in $(cat ~/dotfiles/vs-code-extensions/extensions.txt); do
                    code --install-extension "$extension"
                done
            ;;
             *)
                echo "$config not supported."
            ;;
        esac
    done
    echo ""
}