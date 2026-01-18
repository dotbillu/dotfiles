#!/usr/bin/env bash

if pgrep -x hyprpanel-app >/dev/null; then
  hyprpanel -q
else
  hyprpanel
fi

