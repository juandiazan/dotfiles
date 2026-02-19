#!/bin/bash

detect_pkg_manager() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
        return 0
    elif command -v apt &>/dev/null; then
        echo "apt"
        return 0
    elif command -v dnf &>/dev/null; then
        echo "dnf"
        return 0
    else
        echo "unsupported"
        return 1
    fi
}


detect_aur_helper() {
    if command -v yay &>/dev/null; then
        echo "yay"
    elif command -v paru &>/dev/null; then
        echo "paru"
    else
        echo "none"
    fi
}