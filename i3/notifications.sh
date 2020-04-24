#!/usr/bin/env bash

################# GET INFO of current screen
OFFSET_RE="\+([-0-9]+)\+([-0-9]+)"

# Get the active window position
unset x y w h
eval $(xwininfo -id $(xdotool getactivewindow) |
  sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
         -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
         -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
         -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )

# Loop through each screen and compare the offset with the window position (top left) to find the active monitor
monitor_index=0
while read name width height xoff yoff
do
    if [ "${x}" -ge "$xoff" \
      -a "${y}" -ge "$yoff" \
      -a "${x}" -lt "$(($xoff+$width))" \
      -a "${y}" -lt "$(($yoff+$height))" ]
    then
        monitor=$name
        break
    fi
    ((monitor_index++))
done < <(xrandr | grep " connected 1\| connected primary 1" |
    sed -r "s/^([^ ]*).*\b([-0-9]+)x([-0-9]+)$OFFSET_RE.*$/\1 \2 \3 \4 \5/" |
    sort -nk4,5)

# If we found the active monitor, move the notifications window there.
if [ ! -z "$monitor" ]
then
    win_id=$(xdotool search --onlyvisible --classname plasmashell | tail -1)
    i3-msg [id="$win_id"]  move output $monitor
    exit 0
else
    echo "Couldn't find any monitor for the current window." >&2
    exit 1
fi 
