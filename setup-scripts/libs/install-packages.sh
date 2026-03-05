#!/bin/bash

source ./libs/detect-package-manager.sh || {
    echo "Failed to load pkgm detection script."
    exit 1
}
source ./libs/utilities.sh || {
    echo "Failed to load utilities script."
    exit 1
}

PKG_MANAGER=$(detect_pkg_manager) || {
    echo "No supported package manager found."
    exit 1
}
AUR_HELPER=$(detect_aur_helper)

PROGRAMS=(
    "librewolf"
    "discord"
    "spotify"
    "steam"
    "localsend"
    "obsidian"

    "zsh"
    "spicetify"
    "ckb-next (corsair drivers)"
    "solaar (logitech drivers)"
)

declare -A PACKAGES=(
    [librewolf]="librewolf-bin"
    [discord]="discord"
    [spotify]="spotify"
    [steam]="steam"
    [localsend]="localsend"
    [obsidian]="obsidian"

    [spicetify]="spicetify-cli"
    [ckb-next (corsair drivers)]="ckb-next"
    [solaar (logitech drivers)]="solaar"
)
declare -a SELECTED=()

# ---------
# functions
# ---------
select_software() {
    while true; do
        clear
        show_install_selection_menu
        read -p "Choice: " choice

        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            index=$((choice-1))
            current_prog="${PROGRAMS[$index]}"
            if [[ " ${SELECTED[*]} " == *" $current_prog "* ]]; then
                remove_from_selected "$current_prog"
            else
                SELECTED+=("$current_prog")
            fi
        elif [[ "$choice" == "i" ]]; then
            install_selected_software
            break
        elif [[ "$choice" == "q" ]]; then
            break
        else
            echo "Invalid option."
        fi
    done
}

remove_from_selected() {
    new_selected=()
    for item in "${SELECTED[@]}"; do
        [[ "$item" != "$1" ]] && new_selected+=("$item")
    done
    SELECTED=("${new_selected[@]}")
}

show_install_selection_menu() {
    echo "Select programs to install:"
    for i in "${!PROGRAMS[@]}"; do
        current_prog="${PROGRAMS[$i]}"
        # Check if already selected
        if [[ " ${SELECTED[*]} " == *" $current_prog "* ]]; then
            mark="[x]"
        else
            mark="[ ]"
        fi
        printf "%2d) %s %s\n" $((i+1)) "$mark" "$current_prog"
    done
    echo "i) Install selected"
    echo "q) Quit"
}

install_selected_software(){
    echo "Installing selected software:"
    for program in "${SELECTED[@]}"; do
        echo "Installing $program..."
        pkg_name="${PACKAGES[$program]}"
        install_package "$pkg_name" || echo "Failed to install $program"
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
            install_generic "$PKG_MANAGER" "$pkg"
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