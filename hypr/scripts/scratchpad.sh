
#!/usr/bin/env bash

SCRATCHPADS=(term zen spotify)

# build numbered menu
menu=""
for i in "${!SCRATCHPADS[@]}"; do
  menu+="$((i+1)). ${SCRATCHPADS[$i]}\n"
done

# show menu with tofi
choice=$(printf "%b" "$menu" | tofi)
[ -z "$choice" ] && exit

# handle two possible tofi outputs:
# 1) "N. label" (numbered) -> extract number
# 2) "label" (just the label) -> find index in array
if [[ "$choice" =~ ^([0-9]+)\. ]]; then
  num="${BASH_REMATCH[1]}"
else
  # remove possible leading/trailing whitespace
  selected_label="$(echo "$choice" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  num=""
  for i in "${!SCRATCHPADS[@]}"; do
    if [[ "${SCRATCHPADS[$i]}" == "$selected_label" ]]; then
      num=$((i+1))
      break
    fi
  done
fi

[ -z "$num" ] && exit

hyprctl dispatch "hl.dsp.workspace.toggle_special($num)"
