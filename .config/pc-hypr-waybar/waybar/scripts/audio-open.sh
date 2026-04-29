#!/bin/bash

if pgrep -x wiremix >/dev/null; then
    pkill -x wiremix
else
    kitty --class wiremix wiremix
fi