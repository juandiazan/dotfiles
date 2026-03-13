#!/usr/bin/env bash

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
