#!/bin/bash

# This script finds an icon path for each application.

# --- CONFIGURATION ---
# The theme name is 'Papirus' (Capital P)
icon_theme="Papirus"
fallback_icon="image-missing"
# The path is '32x32', which is confirmed to exist on your system.
icon_path_base="/usr/share/icons/${icon_theme}/32x32/apps"
# --- END CONFIGURATION ---

find_icon() {
    local app_class_lower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Using -iname for a case-insensitive search to find more icons
    # Removed -type f to include symlinks as well
    local found_icon=$(find "$icon_path_base" -maxdepth 1 -iname "${app_class_lower}.*" | head -n 1)

    if [[ -n "$found_icon" ]]; then
        echo "$found_icon"
    else
        # Fallback for some common apps with different names
        case "$app_class_lower" in
            "google-chrome-beta")
                found_icon=$(find "$icon_path_base" -maxdepth 1 -iname "google-chrome.*" | head -n 1)
                ;;
            "code")
                found_icon=$(find "$icon_path_base" -maxdepth 1 -iname "visual-studio-code.*" | head -n 1)
                ;;
        esac

        if [[ -n "$found_icon" ]]; then
            echo "$found_icon"
        else
            echo "$fallback_icon"
        fi
    fi
}

# Main loop
while true; do
    clients_json=$(hyprctl clients -j)
    active_window_address=$(hyprctl activewindow -j | jq -r '.address // ""')
    
    # Build the final output
    final_output="["
    first=true
    
    while IFS= read -r client_line; do
        if [[ -z "$client_line" ]]; then continue; fi
        class=$(echo "$client_line" | jq -r '.class')
        title=$(echo "$client_line" | jq -r '.title')
        address=$(echo "$client_line" | jq -r '.address')
        
        # Check if this client is the active window
        if [[ "$address" == "$active_window_address" ]]; then
            focused=true
        else
            focused=false
        fi
        
        icon=$(find_icon "$class")

        if [[ "$first" == "true" ]]; then
            first=false
        else
            final_output+=","
        fi
        
        final_output+=$(jq -nc \
            --arg class "$class" \
            --arg title "$title" \
            --arg address "$address" \
            --argjson focused "$focused" \
            --arg icon_path "$icon" \
            '{class: $class, title: $title, address: $address, focused: $focused, icon_path: $icon_path}')
    done <<< "$(echo "$clients_json" | jq -c '.[]')"
    
    final_output+="]"
    
    # Output as a single line of compact JSON
    echo "$final_output"
    sleep 1
done