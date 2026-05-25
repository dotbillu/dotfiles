#!/usr/bin/env bash

SCRATCHPADS=(
  "term"
  "zen"
  "spotify"
)

menu=""
for i in "${!SCRATCHPADS[@]}"; do
  menu+="$((i+1)). ${SCRATCHPADS[$i]}\n"
done

choice=$(printf "%b" "$menu" | tofi)

# extract name after "1. "
selected=$(echo "$choice" | sed 's/^[0-9]\+\. //')

[ -n "$selected" ] && pypr toggle "$selected"
