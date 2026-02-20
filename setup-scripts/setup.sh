#!/bin/bash

# ---------
# utilities
# ---------

source ./libs/utilities.sh
source ./libs/detect-package-manager.sh
source ./libs/install-packages.sh

PROGRAMS=("librewolf" "spotify" "spicetify" "steam")

declare -A PACKAGES=(
    [librewolf]="librewolf-bin"
    [spotify]="spotify"
    [spicetify]="spicetify-cli"
    [steam]="steam"
)
declare -a SELECTED=()

# ---------
# functions
# ---------
show_menu() {
    echo "Select programs to install:"
    for i in "${!PROGRAMS[@]}"; do
        prog="${PROGRAMS[$i]}"
        # Check if already selected
        if [[ " ${SELECTED[*]} " == *" $prog "* ]]; then
            mark="[x]"
        else
            mark="[ ]"
        fi
        printf "%2d) %s %s\n" $((i+1)) "$mark" "$prog"
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
            prog="${PROGRAMS[$index]}"
            if [[ " ${SELECTED[*]} " == *" $prog "* ]]; then
                SELECTED=("${SELECTED[@]/$prog}") # remove from selected
            else
                SELECTED+=("$prog")
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