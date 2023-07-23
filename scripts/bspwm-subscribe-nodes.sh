#!/bin/bash
#
# bspwm-subscribe-nodes.sh

node_callback() {
  echo $1 >> ~/.bspeww/node-change.log
  bspc wm -d > ~/.bspeww/bspwm-state.json
  curl http://localhost:3100/read
  curl http://localhost:3100/write
}

desktop_callback() {
  wmctrl -d | grep -F '*' | rev | cut -d ' ' -f 1 | rev >> ~/.bspeww/desktops/selected
}

mkdir -p ~/.bspeww

bspc subscribe node_add node_remove node_transfer | while read line
do
  node_callback "$line"
done &

bspc subscribe desktop_focus | while read line
do
  desktop_callback
done &
