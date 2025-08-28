#!/bin/bash

# Toggle script for eww dock
# Usage: bind this script to Super+B in your window manager

# Check if eww dock window is currently open
if eww active-windows | grep -q "dock"; then
    # Dock is open, close it
    eww close dock
    echo "Eww dock disabled"
else
    # Dock is closed, open it
    eww open dock
    echo "Eww dock enabled"
fi