#!/bin/bash

source ./libs/utilities.sh
source ./libs/detect-package-manager.sh
source ./libs/install-packages.sh
source ./libs/apply-configs.sh

print_menu() {
    print_color $BOLD_GREEN "welcome to setup"

    echo "1 - install software"
    echo "2 - apply configurations on saved dotfiles"
    echo "0 - exit"
}

print_menu
read option

while [ $option -ne 0 ] ; do

    case $option in

    1)
        select_software
    ;; 

    2)
        apply_configs
    ;; 

    *)
        print_color $BOLD_RED "wrong option"
    esac

    print_menu
    read option

done