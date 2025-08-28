#!/bin/bash
while true; do
  battery=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)
  if [ "$status" = "Discharging" ] && [ "$battery" -le 25 ]; then
    notify-send "Battery Low" "Battery is below 25% ($battery%)" -u critical
  fi
  sleep 300
done
