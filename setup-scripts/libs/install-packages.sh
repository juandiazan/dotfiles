#!/usr/bin/env bash

source ./utils/detect-package-manager.sh || {
    echo "Failed to load pkgm detection script."
    exit 1
}
source ./utils/software.sh || {
    echo "Failed to load software list."
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


PKG_MANAGER=$(detect_pkg_manager) || {
    echo "No supported package manager found."
    exit 1
}
AUR_HELPER=$(detect_aur_helper)

declare -a SELECTED=()

select_software() {
    while true; do
        clear
        show_install_selection_menu
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
                SELECTED=("${PROGRAMS[@]}")
            ;;
            "q")
                clear
                break
            ;;
            *)
                if [[ "$choice" =~ ^[1-9]+$ ]]; then
                    index=$((choice-1))
                    current_prog="${PROGRAMS[$index]}"
                    if [[ " ${SELECTED[*]} " == *" $current_prog "* ]]; then
                        remove_from_selected "$current_prog"
                    else
                        SELECTED+=("$current_prog")
                    fi
                else
                    print_color $BOLD_RED "Invalid option. Press enter to continue."
                    read -p ""
                fi
            ;;
        esac
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
    install_actions_menu
}

install_selected_software(){
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
                
                # give permission to modify spotify executable to OS
                sudo chmod a+wr /opt/spotify
                sudo chmod a+wr /opt/spotify/Apps -R

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