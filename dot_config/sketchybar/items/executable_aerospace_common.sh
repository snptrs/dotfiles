#!/bin/sh

# $1: workspace ID

sketchybar --add item space.$1 left \
    --subscribe space.$1 aerospace_workspace_change \
    --set space.$1 \
    background.color=0x44ffffff \
    background.corner_radius=5 \
    background.height=20 \
    background.drawing=off \
    label.padding_left=-4 \
    label.padding_right=8 \
    label="$1" \
    click_script="aerospace workspace $1" \
    script="$CONFIG_DIR/plugins/aerospace.sh $1"
