#!/bin/bash

# Persistent wallpaper script that keeps swww daemon alive

WALLPAPER_DIR="$HOME/.local/share/wallpapers/catpp-mocha-all"
LOG_FILE="$HOME/.config/hypr/logs/wallpaper.log"

log_msg() {
    echo "$(date '+%H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to ensure swww daemon is running
ensure_daemon() {
    if ! pgrep swww-daemon >/dev/null; then
        log_msg "Starting swww daemon..."
        swww-daemon &
        sleep 3
    fi
}

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    ensure_daemon
    
    if swww img "$wallpaper" 2>/dev/null; then
        log_msg "✅ Set: $(basename "$wallpaper")"
        return 0
    else
        log_msg "❌ Failed: $(basename "$wallpaper")"
        return 1
    fi
}

# Main loop
main() {
    log_msg "🎨 Starting persistent wallpaper manager"
    
    # Set initial wallpaper
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
    if [[ -n "$WALLPAPER" ]]; then
        set_wallpaper "$WALLPAPER"
    fi
    
    # Keep running and change wallpaper every 10 minutes
    while true; do
        sleep 600
        
        # Check if daemon is still running, restart if needed
        ensure_daemon
        
        # Get new wallpaper
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
        if [[ -n "$WALLPAPER" ]]; then
            set_wallpaper "$WALLPAPER"
        fi
    done
}

# Cleanup on exit
cleanup() {
    log_msg "🛑 Wallpaper manager stopped"
    exit 0
}

trap cleanup SIGTERM SIGINT

main "$@"