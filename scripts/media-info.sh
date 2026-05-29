#!/usr/bin/env bash
# Outputs current media state as JSON for eww consumption.
# Ignores browser players to match waybar mpris behavior.

IGNORE="--ignore-player=firefox,librewolf"

fallback='{"title":"Nothing playing","artist":"","status":"Stopped","position":0,"length":1,"player":""}'

if ! command -v playerctl &>/dev/null; then
    echo "$fallback"
    exit 0
fi

status=$(playerctl $IGNORE status 2>/dev/null)
if [ -z "$status" ] || [[ "$status" == *"No players"* ]]; then
    echo "$fallback"
    exit 0
fi

title=$(playerctl $IGNORE metadata title 2>/dev/null | sed 's/"/\\"/g' | tr -d '\n')
artist=$(playerctl $IGNORE metadata artist 2>/dev/null | sed 's/"/\\"/g' | tr -d '\n')
position=$(playerctl $IGNORE position 2>/dev/null | awk '{printf "%.0f", $1}')
length=$(playerctl $IGNORE metadata mpris:length 2>/dev/null | awk '{printf "%.0f", $1/1000000}')
player=$(playerctl $IGNORE metadata --format '{{playerName}}' 2>/dev/null | awk '{print toupper(substr($0,1,1)) substr($0,2)}')

[ -z "$position" ] && position=0
[ -z "$length" ] && length=1
[ "$length" = "0" ] && length=1

printf '{"title":"%s","artist":"%s","status":"%s","position":%s,"length":%s,"player":"%s"}\n' \
    "$title" "$artist" "$status" "$position" "$length" "$player"
