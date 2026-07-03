DIR="$HOME/Pictures/Screenshots"

if pgrep -x eog >/dev/null; then
  pkill -x eog
else
  latest=$(find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) \
    -printf "%T@ %p\n" 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)

  [ -n "$latest" ] && eog "$latest"
fi

