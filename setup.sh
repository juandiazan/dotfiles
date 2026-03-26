#!/usr/bin/env bash

SETUP_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SETUP_SCRIPT_DIR/src/ui/colored_print.sh"
source "$SETUP_SCRIPT_DIR/src/ui/menus.sh"
source "$SETUP_SCRIPT_DIR/src/pkg/install-packages.sh"
source "$SETUP_SCRIPT_DIR/src/config/apply-configs.sh"
source "$SETUP_SCRIPT_DIR/src/config/backup-configs.sh"

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
        select_configs
    ;; 

    3)
        clear
        select_backups
    ;;

    *)
        print_color $BOLD_RED "Invalid option."
    esac

    main_menu
    read option

done