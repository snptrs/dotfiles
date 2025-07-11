#!/bin/bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item aerospace_dummy left \
  --set aerospace_dummy display=0 \
  script="$PLUGIN_DIR/spaces.sh" \
  --subscribe aerospace_dummy aerospace_workspace_change

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for sid in $(aerospace list-workspaces --monitor $m); do
    sketchybar --add space space.$sid left \
      --set space.$sid space=$sid \
      icon=$sid \
      background.color=$TRANSPARENT \
      label.color=$ACCENT_COLOR \
      icon.color=$ACCENT_COLOR \
      display=$m \
      label.font="sketchybar-app-font:Regular:12.0" \
      icon.font="SF Pro:Semibold:12.0" \
      label.padding_right=10 \
      label.y_offset=-1 \
      click_script="$PLUGIN_DIR/space_click.sh $sid"
  done
done
