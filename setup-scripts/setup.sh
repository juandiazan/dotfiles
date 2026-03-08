source ./libs/utilities.sh
source ./libs/detect-package-manager.sh
source ./libs/install-packages.sh
source ./libs/apply-configs.sh

print_color $BOLD_GREEN "Welcome to app and config setup!"

print_menu() {
    echo "======== 1 - Install software                     ========"
    echo "======== 2 - Apply backups of configuration files ========"
    echo "======== 0 - Exit                                 ========"
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
        print_color $BOLD_RED "Invalid option."
    esac

    print_menu
    read option

done