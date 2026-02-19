#!/bin/bash

# ---------
# utilities
# ---------

source ./libs/utilities.sh

PROGRAMS=("spotify" "spicetify" "steam" "librewolf")
SELECTED=()

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
    echo "a) Install selected"
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
        elif [[ "$choice" == "a" ]]; then
            break
        elif [[ "$choice" == "q" ]]; then
            SELECTED=()
            break
        else
            echo "Invalid option."
        fi
    done
}


list_selected_software(){
    echo "Selected software:"
    for program in "${SELECTED[@]}"; do
        echo "- $program"
    done
}

install_selected_software(){
    echo "Installing selected software:"
    for program in "${SELECTED[@]}"; do
        echo "Installing $program..."
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
    list_selected_software
     ;; 

    3)
    install_selected_software
     ;; 

    4)
    apply_configurations
     ;; 

    *)
        print_color $BOLD_RED "wrong option"

    esac

    print_menu
    read option

done