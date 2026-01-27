#!/bin/bash

# ---------
# utilities
# ---------

# color constants
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_PURPLE='\033[1;35m'
NO_COLOR='\033[0m'

# param 1 = color
# param 2 = text
print_color() {
echo -e $1$2$NO_COLOR
}

print_menu() {
print_color $BOLD_PURPLE "welcome to setup"

echo "1 - select software to install"
echo "2 - check software to install"
echo "3 - install selected software"
echo "0 - exit"
}

# ---------
# functions
# ---------

select_software() {
echo "todo"
echo ""
}

list_selected_software(){
echo "todo"
echo ""
}

install_selected_software(){
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

    *)
        print_color $BOLD_RED "wrong option"

    esac

    print_menu
    read option

done