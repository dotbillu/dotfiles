#!/bin/bash

# Emergency wallpaper fix script

echo "🚨 Emergency wallpaper fix - setting wallpaper now..."

# Kill everything
pkill -f wallcycle 2>/dev/null
pkill swww-daemon 2>/dev/null
sleep 1

# Get a wallpaper
WALLPAPER=$(find ~/.local/share/wallpapers/catpp-mocha-all -name "*.jpg" -o -name "*.png" | head -1)

if [[ -f "$WALLPAPER" ]]; then
    echo "Found wallpaper: $(basename "$WALLPAPER")"
    
    # Try swww method
    echo "Trying swww..."
    swww-daemon &
    sleep 4
    
    if swww img "$WALLPAPER" 2>/dev/null; then
        echo "✅ Wallpaper set with swww!"
    else
        echo "❌ swww failed, trying hyprctl..."
        pkill swww-daemon 2>/dev/null
        
        # Try hyprctl method
        hyprctl hyprpaper preload "$WALLPAPER" 2>/dev/null
        hyprctl hyprpaper wallpaper ",$WALLPAPER" 2>/dev/null
        echo "Tried hyprctl method"
    fi
else
    echo "❌ No wallpaper found!"
fi

echo "Emergency fix complete. Check if wallpaper is visible now."