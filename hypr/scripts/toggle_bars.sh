#!/bin/bash

# Toggle script for both eww dock and waybar
# Usage: bind this script to Super+B in your window manager
# Both bars will be synchronized - either both enabled or both disabled

# Check if eww dock window is currently open
if eww active-windows | grep -q "dock"; then
    # Bars are open, close both
    eww close dock
    pkill waybar
    echo "Eww dock and Waybar disabled"
else
    # Bars are closed, open both
    eww open dock
    waybar &
    echo "Eww dock and Waybar enabled"
fi