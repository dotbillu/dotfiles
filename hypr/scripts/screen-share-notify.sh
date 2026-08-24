#!/bin/bash

STATE_FILE="/tmp/screen-share-dnd.state"

while true; do
    if pw-cli list-objects Node 2>/dev/null | grep -q 'node.name = "xdg-desktop-portal-hyprland"'; then
        if [[ ! -f "$STATE_FILE" ]]; then
            swaync-client --dnd-on
            touch "$STATE_FILE"
        fi
    else
        if [[ -f "$STATE_FILE" ]]; then
            swaync-client --dnd-off
            rm -f "$STATE_FILE"
        fi
    fi

    sleep 2
done
