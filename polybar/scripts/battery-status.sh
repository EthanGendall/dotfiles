#!/bin/bash

# Hex color codes for Polybar
RED="%{F#ff0000}"
WHITE="%{F#ffffff}"
BLUE="%{F#81a1c1}"
RESET="%{F-}"

# Use only internal batteries BAT0 or BAT1, ignore others like mouse
battery_info=$(acpi -b | grep -E '^Battery [01]:')

if [[ -z "$battery_info" ]]; then
    echo "No main battery found"
    exit 1
fi

# Extract percentage, status, and time (HH:MM)
percent=$(echo "$battery_info" | grep -Po '[0-9]+(?=%)' | head -n1)
status=$(echo "$battery_info" | grep -oP 'Charging|Discharging|Full|Not charging' | head -n1)
time=$(echo "$battery_info" | grep -oP '[0-9]{2}:[0-9]{2}' | head -n1)

# Format percentage
if [[ "$percent" -le 10 ]]; then
    percent_display="${RED}${percent}%${RESET}"
else
    percent_display="${percent}%${RESET}"
fi

# Format time display
time_display=""
if [[ "$status" == "Discharging" && -n "$time" ]]; then
    time_display="${BLUE}${time}${RESET}"
elif [[ "$status" == "Charging" && "$percent" -lt 80 && -n "$time" ]]; then
    time_display="${BLUE}${time}${RESET}"
fi

# Output in requested format
if [[ -n "$time_display" ]]; then
    echo -e "${time_display} ${percent_display}"
else
    echo -e "${percent_display}"
fi
