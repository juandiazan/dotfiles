#!/usr/bin/env bash

PROGRAMS=(
    "librewolf"
    "discord"
    "spotify"
    "steam"
    "localsend"
    "obsidian"

    "lazygit"
    "lazydocker"

    "fastfetch"
    "kitty"
    "zsh"
    "oh-my-zsh"
    "starship"
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

    [lazygit]="lazygit"
    [lazydocker]="lazydocker"

    [fastfetch]="fastfetch"
    [kitty]="kitty"
    [zsh]="zsh"
    [oh-my-zsh]="oh-my-zsh"
    [starship]="starship"
    [spicetify (and marketplace)]="spicetify-cli"
    [swaync]="swaync"
    [ckb-next (corsair drivers)]="ckb-next"
    [solaar (logitech drivers)]="solaar"
)