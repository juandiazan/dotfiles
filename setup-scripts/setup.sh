#!/bin/bash

# ---------
# utilities
# ---------

source ./libs/utilities.sh
source ./libs/detect-package-manager.sh
source ./libs/install-packages.sh

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
show_menu() {
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


select_software() {
    while true; do
        clear
        show_menu
        read -p "Choice: " choice

        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            index=$((choice-1))
            current_prog="${PROGRAMS[$index]}"
            if [[ " ${SELECTED[*]} " == *" $current_prog "* ]]; then
                SELECTED=("${SELECTED[@]/$current_prog}") # remove from selected
            else
                SELECTED+=("$current_prog")
            fi
        elif [[ "$choice" == "i" ]]; then
            install_selected_software
            break
        elif [[ "$choice" == "q" ]]; then
            SELECTED=()
            break
        else
            echo "Invalid option."
        fi
    done
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

apply_configurations() {
echo "todo"
echo ""
}

# ---------
# main flow
# ---------

print_menu
read option

while [ $option -ne 0 ] ; do

    case $option in

    1)
    select_software
     ;; 

    2)
    apply_configurations
     ;; 

    *)
        print_color $BOLD_RED "wrong option"
    esac

    print_menu
    read option

done