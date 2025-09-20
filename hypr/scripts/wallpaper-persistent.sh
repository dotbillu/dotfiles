#!/usr/bin/env bash

# --- CONFIGURATION ---
# Set the directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/.local/share/wallpapers/catpp-mocha-all"

# Set the time in seconds to wait before changing the wallpaper (270s = 4.5 minutes)
SLEEP_INTERVAL=270

# --- SCRIPT ---

# Function to find and set a new random wallpaper
set_random_wallpaper() {
    # Find all compatible image files and pick one at random
    local new_wallpaper
    new_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

    # Check if a wallpaper was found
    if [[ -z "$new_wallpaper" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR. Will try again later."
        return 1 # Just skip this cycle, don't exit the script
    fi

    # Use hyprctl to change the wallpaper
    hyprctl hyprpaper preload "$new_wallpaper"
    hyprctl hyprpaper wallpaper ",$new_wallpaper"
}


# Main function to run the script
main() {
    # Wait until hyprpaper's IPC socket is active and ready
    until hyprctl hyprpaper listactive > /dev/null 2>&1; do
        sleep 1
    done

    # Set an initial wallpaper on script start
    set_random_wallpaper

    # Loop indefinitely to change wallpaper periodically
    while true; do
        sleep "$SLEEP_INTERVAL"
        set_random_wallpaper
    done
}

# Gracefully exit when the script is terminated
trap 'exit 0' SIGTERM SIGINT

# Run the script
main
