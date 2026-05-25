#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/detect-package-manager.sh" || {
    echo "Failed to load pkgm detection script."
    exit 1
}
source "$SCRIPT_DIR/packages.sh" || {
    echo "Failed to load software list."
    exit 1
}
source "$SETUP_DIR/src/ui/menus.sh" || {
    echo "Failed to load menu script."
    exit 1
}
source "$SETUP_DIR/src/ui/colored_print.sh" || {
    echo "Failed to load special print script."
    exit 1
}


PKG_MANAGER=$(detect_pkg_manager) || {
    echo "No supported package manager found."
    exit 1
}
AUR_HELPER=$(detect_aur_helper)

declare -a SELECTED=()

CATEGORIES=("Apps" "Dev Tools" "TUIs" "Customization")
CATEGORY_ARRAYS=("PROGRAMS_APPS" "PROGRAMS_DEV" "PROGRAMS_TUI" "PROGRAMS_CUSTOMIZATION")

select_software() {
    while true; do
        clear
        show_category_menu
        read -p "Choice: " choice

        case $choice in
            "i")
                install_selected_software
                break
                ;;
            "c")
                SELECTED=()
                ;;
            "s")
                SELECTED=()
                for arr_name in "${CATEGORY_ARRAYS[@]}"; do
                    declare -n _all="$arr_name"
                    for prog in "${_all[@]}"; do
                        SELECTED+=("$prog")
                    done
                    unset -n _all
                done
                ;;
            "q")
                clear
                break
                ;;
            *)
                if [[ "$choice" =~ ^[1-4]$ ]]; then
                    index=$((choice - 1))
                    select_category_software "${CATEGORIES[$index]}" "${CATEGORY_ARRAYS[$index]}"
                else
                    print_color $BOLD_RED "Invalid option. Press enter to continue."
                    read -p ""
                fi
                ;;
        esac
    done
}

show_category_menu() {
    echo "Install software - select a category:"
    echo ""
    for i in "${!CATEGORIES[@]}"; do
        local arr_name="${CATEGORY_ARRAYS[$i]}"
        declare -n _menu="$arr_name"
        local total=${#_menu[@]}
        local count=0
        for prog in "${_menu[@]}"; do
            [[ " ${SELECTED[*]} " == *" $prog "* ]] && ((count++))
        done
        unset -n _menu
        printf "  %d) %-20s (%d/%d selected)\n" $((i+1)) "${CATEGORIES[$i]}" "$count" "$total"
    done
    echo ""
    install_actions_menu
}

select_category_software() {
    local category_name="$1"
    local arr_name="$2"
    declare -n _cat="$arr_name"

    while true; do
        clear
        show_category_item_menu "$category_name" "$arr_name"
        read -p "Choice: " choice

        case $choice in
            "s")
                for prog in "${_cat[@]}"; do
                    [[ " ${SELECTED[*]} " != *" $prog "* ]] && SELECTED+=("$prog")
                done
                ;;
            "c")
                for prog in "${_cat[@]}"; do
                    remove_from_selected "$prog"
                done
                ;;
            "b")
                break
                ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]]; then
                    index=$((choice - 1))
                    if [[ $index -ge 0 && $index -lt ${#_cat[@]} ]]; then
                        current_prog="${_cat[$index]}"
                        if [[ " ${SELECTED[*]} " == *" $current_prog "* ]]; then
                            remove_from_selected "$current_prog"
                        else
                            SELECTED+=("$current_prog")
                        fi
                    else
                        print_color $BOLD_RED "Invalid option. Press enter to continue."
                        read -p ""
                    fi
                else
                    print_color $BOLD_RED "Invalid option. Press enter to continue."
                    read -p ""
                fi
                ;;
        esac
    done
}

show_category_item_menu() {
    local category_name="$1"
    declare -n _items="$2"

    echo "[$category_name] Select programs to install:"
    echo ""
    for i in "${!_items[@]}"; do
        local current_prog="${_items[$i]}"
        local mark="[ ]"
        [[ " ${SELECTED[*]} " == *" $current_prog "* ]] && mark="[x]"
        printf "  %2d) %s %s\n" $((i+1)) "$mark" "$current_prog"
    done
    echo ""
    install_category_actions_menu
}

remove_from_selected() {
    local new_selected=()
    for item in "${SELECTED[@]}"; do
        [[ "$item" != "$1" ]] && new_selected+=("$item")
    done
    SELECTED=("${new_selected[@]}")
}

install_selected_software() {
    echo "Installing selected software:"
    for program in "${SELECTED[@]}"; do
        print_color $BOLD_PURPLE "=====> Installing $program..."
        pkg_name="${PACKAGES[$program]}"
        case $program in
            "oh-my-zsh")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                ;;
            "spicetify (and marketplace)")
                install_package "$pkg_name" || echo "Failed to install $program"
                curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

                sudo chmod a+wr /opt/spotify
                sudo chmod a+wr /opt/spotify/Apps -R

                install_package "spicetify-themes-git" || echo "Failed to install spicetify themes package"

                spicetify backup apply enable-devtools
                ;;
            *)
                install_package "$pkg_name" || echo "Failed to install $program"
                ;;
        esac
    done
    echo ""
}

install_package() {
    local pkg="$1"

    case "$PKG_MANAGER" in
        pacman)
            install_pkg_arch_based "$pkg"
            ;;
        apt|dnf)
            install_pkg_generic "$PKG_MANAGER" "$pkg"
            ;;
        *)
            echo "Unsupported package manager"
            return 1
            ;;
    esac
}

install_pkg_arch_based() {
    sudo pacman -S --needed --noconfirm "$1" || {
        if [[ "$AUR_HELPER" != "none" ]]; then
            $AUR_HELPER -S --needed --noconfirm "$1" || return 1
        else
            echo "Could not install $1: not in repo and no AUR helper found."
            return 1
        fi
    }

    return 0
}

install_pkg_generic() {
    local cmd="$1"
    local pkg="$2"

    sudo "$cmd" install -y "$pkg" || {
        echo "Failed to install package $pkg with command $cmd"
        return 1
    }

    return 0
}
