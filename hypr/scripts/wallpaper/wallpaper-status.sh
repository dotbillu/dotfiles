#!/bin/bash

echo "🎨 Wallpaper Status Check"
echo "========================"

# Check if wallpaper manager is running
if pgrep -f wallpaper-persistent >/dev/null; then
    echo "✅ Wallpaper manager: RUNNING (PID: $(pgrep -f wallpaper-persistent))"
elif pgrep -f wallcycle >/dev/null; then
    echo "✅ Wallpaper cycling: RUNNING (PID: $(pgrep -f wallcycle))"
else
    echo "❌ Wallpaper manager: NOT RUNNING"
fi

# Check if swww daemon is running
if pgrep swww-daemon >/dev/null; then
    echo "✅ swww daemon: RUNNING (PID: $(pgrep swww-daemon))"
else
    echo "❌ swww daemon: NOT RUNNING"
fi

# Check wallpaper directory
if [[ -d ~/.local/share/wallpapers/catpp-mocha-all ]]; then
    WALLPAPER_COUNT=$(find ~/.local/share/wallpapers/catpp-mocha-all -name "*.jpg" -o -name "*.png" | wc -l)
    echo "✅ Wallpaper directory: EXISTS ($WALLPAPER_COUNT wallpapers)"
else
    echo "❌ Wallpaper directory: NOT FOUND"
fi

# Show recent log entries
echo ""
echo "📝 Recent log entries:"
if [[ -f ~/.config/hypr/logs/wallpaper.log ]]; then
    tail -3 ~/.config/hypr/logs/wallpaper.log
else
    echo "No log file found"
fi

echo ""
echo "💡 Quick fixes:"
echo "  • Set wallpaper now: ~/.config/hypr/scripts/wallpaper/emergency-wallpaper.sh"
echo "  • Restart cycling: pkill -f wallcycle && ~/.config/hypr/wallcycle.sh &"
echo "  • Reload Hyprland: hyprctl reload"