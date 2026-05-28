#!/usr/bin/env bash

PROGRAMS_APPS=(
    "librewolf"
    "discord"
    "spotify"
    "steam"
    "localsend"
    "obsidian"
)

PROGRAMS_DEV=(
    "git"
    "docker"
    "claude"
)

PROGRAMS_TUI=(
    "lazygit"
    "lazydocker"
    "yazi"
    "kew"
    "eza"
    "bat"
)

PROGRAMS_CUSTOMIZATION=(
    "fastfetch"
    "kitty"
    "zsh"
    "oh-my-zsh"
    "zsh-syntax-highlighting"
    "starship"
    "rofi"
    "spicetify (and marketplace)"
    "swaync"
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

    [git]="git"
    [docker]="docker"
    [claude]="claude-code"

    [lazygit]="lazygit"
    [lazydocker]="lazydocker"
    [yazi]="yazi"
    [kew]="kew"
    [eza]="eza"
    [bat]="bat"

    [fastfetch]="fastfetch"
    [kitty]="kitty"
    [zsh]="zsh"
    [oh-my-zsh]="oh-my-zsh"
    [zsh-syntax-highlighting]="zsh-syntax-highlighting"
    [starship]="starship"
    [rofi]="rofi"
    ["spicetify (and marketplace)"]="spicetify-cli"
    [swaync]="swaync"
    ["ckb-next (corsair drivers)"]="ckb-next"
    ["solaar (logitech drivers)"]="solaar"
)
