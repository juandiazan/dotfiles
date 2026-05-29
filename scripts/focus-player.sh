#!/usr/bin/env bash
# Brings the active media player window into focus.
# Tries matching by class first, then by title as fallback.

IGNORE="--ignore-player=firefox,librewolf"
player=$(playerctl $IGNORE metadata --format '{{playerName}}' 2>/dev/null)

[ -z "$player" ] && exit 0

# Find which workspace the player window lives on
workspace=$(hyprctl -j clients 2>/dev/null | \
    jq -r --arg p "$player" \
    '.[] | select(.class | ascii_downcase | test($p)) | .workspace.id' | \
    head -1)

[ -z "$workspace" ] || [ "$workspace" = "null" ] && exit 0

hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace\" })"
