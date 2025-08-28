#!/bin/bash

# PID file to track the delay process
PID_FILE="/tmp/eww_preview_delay.pid"

case "$1" in
    "hover")
        # Kill any existing delay process
        if [ -f "$PID_FILE" ]; then
            kill $(cat "$PID_FILE") 2>/dev/null
            rm -f "$PID_FILE"
        fi
        
        # DELAYED: Start window preview in background
        (
            # Store our PID
            echo $ > "$PID_FILE"
            
            # Wait for 1.2 seconds (1200ms)
            sleep 1.2
            
            # Check if we're still supposed to run (PID file still exists and contains our PID)
            if [ -f "$PID_FILE" ] && [ "$(cat "$PID_FILE")" = "$" ]; then
                # Store current window and switch with smooth transition
                current=$(hyprctl activewindow -j | jq -r '.address')
                # Only store original if it's different from the target
                if [ "$current" != "$2" ]; then
                    eww update original_window="$current" &
                fi
                # Enable ultra-slow fade transitions for smooth preview
                hyprctl keyword animation "fade,1,0.005,default"
                hyprctl keyword animation "fadeIn,1,0.005,default"
                hyprctl keyword animation "fadeOut,1,0.005,default"
                hyprctl dispatch focuswindow address:"$2"
                
                # Clean up PID file
                rm -f "$PID_FILE"
            fi
        ) &
        ;;
    "unhover")
        # Kill any pending delay process
        if [ -f "$PID_FILE" ]; then
            kill $(cat "$PID_FILE") 2>/dev/null
            rm -f "$PID_FILE"
        fi
        
        # Smooth switch back to original window
        eww update hovered_window="" &
        original=$(eww get original_window)
        if [ -n "$original" ] && [ "$original" != "null" ] && [ "$original" != "$2" ]; then
            hyprctl keyword animation "fade,1,0.005,default"
            hyprctl keyword animation "fadeIn,1,0.005,default"
            hyprctl keyword animation "fadeOut,1,0.005,default"
            hyprctl dispatch focuswindow address:"$original"
        fi
        ;;
    "click")
        # Kill any pending delay process
        if [ -f "$PID_FILE" ]; then
            kill $(cat "$PID_FILE") 2>/dev/null
            rm -f "$PID_FILE"
        fi
        
        # Reset to normal speed for clicks
        hyprctl keyword animation "fade,1,3.0,quick"
        hyprctl keyword animation "fadeIn,1,1.7,almostLinear"
        hyprctl keyword animation "fadeOut,1,1.5,almostLinear"
        eww update original_window="$2" &
        eww update hovered_window="" &
        eww update visual_hover="" &
        hyprctl dispatch focuswindow address:"$2"
        ;;
esac