#!/bin/bash
if eww active-windows | grep -q "dock"; then
    eww close dock
    pkill waybar
    echo "Eww dock and Waybar disabled"
else
    eww open dock
    waybar &
    echo "Eww dock and Waybar enabled"
fi
