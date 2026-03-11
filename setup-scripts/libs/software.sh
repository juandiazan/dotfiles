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
    "zsh"
    "oh-my-zsh"
    "spicetify (and marketplace)"
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
    [zsh]="zsh"
    [oh-my-zsh]="oh-my-zsh"
    [spicetify (and marketplace)]="spicetify-cli"
    [ckb-next (corsair drivers)]="ckb-next"
    [solaar (logitech drivers)]="solaar"
)