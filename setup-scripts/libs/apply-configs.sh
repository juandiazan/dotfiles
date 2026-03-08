source ./libs/config-files.sh || {
    echo "Failed to load config file list."
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
                break
            ;;
        esac

        if [[ "$choice" =~ ^[1-9]+$ ]]; then
            index=$((choice-1))
            current_config="${CONFIGS[$index]}"
            if [[ " ${SELECTED_CONFIGS[*]} " == *" $current_config "* ]]; then
                remove_config_from_selected "$current_config"
            else
                SELECTED_CONFIGS+=("$current_config")
            fi
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
    echo "===================="
    echo "a) Apply selected"
    echo "c) Clear selection"
    echo "s) Select all"
    echo "q) Quit"
    echo "===================="
}

apply_selected_configs(){
    echo "Applying selected configurations:"
    for config in "${SELECTED_CONFIGS[@]}"; do
        echo "Applying $config..."
        case $config in
            "zsh and omz config (.zshrc)")
                cp ~/dotfiles/zsh-and-omz-config/.zshrc ~/
                chsh -s $(which zsh)
                source ~/.zshrc
                print_color $BOLD_YELLOW "=====> Log out and log back in for effects to apply."
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
             *)
                echo "$config not supported."
            ;;
        esac
    done
    echo ""
}