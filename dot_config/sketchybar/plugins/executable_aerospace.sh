#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi

if [ "$1" = "$PREV_WORKSPACE" ]; then
	SBAR_AEROSPACE_WORKSPACES=$(sketchybar --query bar | jq .items | jq -r '.[] | select(startswith("space.")) | ltrimstr("space.")')
	if ! printf "%s\n" "${SBAR_AEROSPACE_WORKSPACES[@]}" | grep -Fxq -- "$FOCUSED_WORKSPACE"; then
		# If current focused workspace is shown on the sketchybar
		sh "$CONFIG_DIR/items/aerospace_common.sh" "$FOCUSED_WORKSPACE"
	fi
	ACTIVE_WORKSPACES=$(aerospace list-windows --all --format %{workspace} | sort -u)
	if ! printf "%s\n" "${ACTIVE_WORKSPACES[@]}" | grep -Fxq -- "$1"; then
		# If the previous workspace doesn't have any windows
		sketchybar --remove space.$1
	fi
fi
