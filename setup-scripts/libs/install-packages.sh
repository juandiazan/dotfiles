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