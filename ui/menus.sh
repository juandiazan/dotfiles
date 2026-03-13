#!/usr/bin/env bash

main_menu() {
    echo "=========================================="
    echo "|        1 - Install software            |"
    echo "|        2 - Apply configurations        |"
    echo "|        3 - Backup configurations       |"
    echo "|        0 - Exit                        |"
    echo "=========================================="
}

config_actions_menu() {
    echo "======================"
    echo "| a) Apply selected  |"
    echo "| c) Clear selection |"
    echo "| s) Select all      |"
    echo "| q) Quit            |"
    echo "======================"
}

install_actions_menu() {
    echo "======================="
    echo "| i) Install selected |"
    echo "| c) Clear selection  |"
    echo "| s) Select all       |"
    echo "| q) Quit             |"
    echo "======================="
}

backup_actions_menu() {
    echo "======================="
    echo "| b) Backup selected  |"
    echo "| c) Clear selection  |"
    echo "| s) Select all       |"
    echo "| q) Quit             |"
    echo "======================="
}