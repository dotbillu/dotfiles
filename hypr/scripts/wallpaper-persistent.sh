#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/catpp-mocha-all"
SLEEP_INTERVAL=270
set_random_wallpaper() {
    local new_wallpaper
    new_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
    if [[ -z "$new_wallpaper" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR. Exiting."
        exit 1
    fi
    hyprctl hyprpaper preload "$new_wallpaper"
    hyprctl hyprpaper wallpaper ",$new_wallpaper"
}
main() {
    sleep 2 
    set_random_wallpaper
    while true; do
        sleep "$SLEEP_INTERVAL"
        ensure_hyprpaper
        set_random_wallpaper
    done
}
trap 'exit 0' SIGTERM SIGINT
main
