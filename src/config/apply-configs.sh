#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOTFILES_DIR="$SETUP_DIR"
BACKUPS_DIR="$DOTFILES_DIR/backups"

source "$SCRIPT_DIR/configs.sh" || {
    echo "Failed to load config file list."
    exit 1
}
source "$SETUP_DIR/ui/menus.sh" || {
    echo "Failed to load menu script."
    exit 1
}
source "$SETUP_DIR/ui/colored_print.sh" || {
    echo "Failed to load special print script."
    exit 1
}

declare -a SELECTED_CONFIGS=()

select_configs() {
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
                git config credential.helper store
                
                echo "Enter your name"
                read name

                echo "Enter your email"
                read email

                git config --global user.name "$name"
                git config --global user.email "$email"
            ;;
            "zsh and omz config (.zshrc)")
                cp "$BACKUPS_DIR/zsh-omz/.zshrc" "$HOME/"
                chsh -s "$(command -v zsh)"
                print_color $BOLD_YELLOW "=====> Log out and log back in, restart your terminal or run \"exec zsh\" for effects to apply."
            ;;
            "kitty config")
                cp "$BACKUPS_DIR/kitty-config"/* "$HOME/.config/kitty/"
            ;;
            "starship config")
                cp "$BACKUPS_DIR/starship-config/starship.toml" "$HOME/.config/starship.toml"
            ;;
            "fastfetch config")
                mkdir -p "$HOME/.config/fastfetch"
                cp "$BACKUPS_DIR/fastfetch-config/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
            ;;
            "spicetify theme")
                spicetify config current_theme Sleek color_scheme Elementary
                spicetify apply
            ;;
            "omarchy hyprland files")
                echo "TODO"
            ;;
            "waybar hyprland files (jsonc and css)")
                cp "$BACKUPS_DIR/waybar"/* "$HOME/.config/waybar/"
            ;;
            "browser bookmarks")
                echo "TODO"
            ;;
            "vs code settings and extensions")
                cp "$BACKUPS_DIR/vs-code/settings.json" "$HOME/.config/Code/User/"

                for extension in $(cat "$BACKUPS_DIR/vs-code/extensions.txt"); do
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