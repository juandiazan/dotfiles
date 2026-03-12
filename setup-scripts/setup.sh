#!/usr/bin/env bash

source ./ui/colored_print.sh
source ./ui/menus.sh
source ./libs/detect-package-manager.sh
source ./libs/install-packages.sh
source ./libs/apply-configs.sh

print_color $BOLD_GREEN "Welcome to app and config setup!"

main_menu
read option

while [ $option -ne 0 ] ; do

    case $option in

    1)
        clear
        select_software
    ;; 

    2)
        clear
        apply_configs
    ;; 

    *)
        print_color $BOLD_RED "Invalid option."
    esac

    main_menu
    read option

done