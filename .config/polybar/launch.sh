#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done


# Launch bar
polybar top-left &
polybar top-middle-left &
polybar top-middle &
polybar top-middle-right &
polybar top-right &

# Define bars per monitors
declare -A ARRANGEMENTS=(["$mainmonitor"]="top-left,top-middle-left,top-middle,top-middle-right,top-right" ["$secondmonitor"]="top-left,top-middle-left,top-middle,top-middle-right,top-right")

# Each key
for MONITOR in "${!ARRANGEMENTS[@]}"; do
    # split at `,` into array
    while IFS=',' read -ra BARLIST; do
        # for each bar (seperated by `,`) at current key
        for BAR in "${BARLIST[@]}"; do
            MONITOR="$MONITOR" polybar --reload "$BAR" &
        done
    done <<< "${ARRANGEMENTS[$MONITOR]}"
done
