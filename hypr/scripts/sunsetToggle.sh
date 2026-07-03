if pgrep -x hyprsunset >/dev/null; then
pkill hyprsunset
else hyprsunset --temperature 5000
fi
