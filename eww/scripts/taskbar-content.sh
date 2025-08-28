#!/bin/bash

# Get clients from the original script
clients=$(~/.config/eww/scripts/get-clients.sh)

# Parse JSON and create taskbar content without trailing divider
echo "$clients" | jq -r '
  if length == 0 then
    ""
  else
    . as $clients |
    to_entries |
    map(
      .value as $client |
      .key as $index |
      "(eventbox :onhover \"~/.config/eww/scripts/window-preview.sh hover '\($client.address)'\" :onhoverlost \"~/.config/eww/scripts/window-preview.sh unhover '\($client.address)'\" (button :class \"task-item \($client.focused or false | if . then "active" else "" end)\" :onclick \"~/.config/eww/scripts/window-preview.sh click '\($client.address)'\" :tooltip \"\($client.title)\" (image :path \"\($client.icon_path)\" :image-width 48 :image-height 48)))" +
      (if $index < (($clients | length) - 1) then "(label :class \"divider-app\" :text \"|\")" else "" end)
    ) |
    join("")
  end
'