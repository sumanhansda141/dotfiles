#!/usr/bin/env bash

# Pick whichever launcher is actually installed, in your preferred order
if command -v rofi &>/dev/null; then
    LAUNCHER="rofi -show drun"
    KILL="rofi"
elif command -v wofi &>/dev/null; then
    LAUNCHER="wofi --show drun"
    KILL="wofi"
elif command -v fuzzel &>/dev/null; then
    LAUNCHER="fuzzel"
    KILL="fuzzel"
elif command -v tofi &>/dev/null; then
    LAUNCHER="tofi-drun --drun-launch=true"
    KILL="tofi"
else
    notify-send "No app launcher found" "Install rofi, wofi, fuzzel, or tofi"
    exit 1
fi

case "$1" in
    kill)
        killall "$KILL"
        ;;
    *)
        $LAUNCHER
        ;;
esac
