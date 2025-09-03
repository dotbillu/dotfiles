#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/wallpapers/catpp-mocha-all"
LOG_FILE="$HOME/.config/hypr/logs/wallpaper.log"

log_msg() {
    echo "$(date '+%H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

ensure_daemon() {
    if ! pgrep swww-daemon >/dev/null; then
        log_msg "Starting swww daemon..."
        swww-daemon &
        sleep 3
    fi
}

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

main() {
    log_msg "🎨 Starting persistent wallpaper manager"
    
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
    if [[ -n "$WALLPAPER" ]]; then
        set_wallpaper "$WALLPAPER"
    fi
    
    while true; do
        sleep 600
        ensure_daemon
        
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
        if [[ -n "$WALLPAPER" ]]; then
            set_wallpaper "$WALLPAPER"
        fi
    done
}

cleanup() {
    log_msg "🛑 Wallpaper manager stopped"
    exit 0
}

trap cleanup SIGTERM SIGINT

main "$@"