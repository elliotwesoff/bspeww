#!/bin/bash
#
# bspwm-subscribe-nodes.sh

node_callback() {
  echo $1 >> ~/.bspeww/node-change.log
  bspc wm -d > ~/.bspeww/bspwm-state.json
  curl http://localhost:3100/read
}

mkdir -p ~/.bspeww

echo subscribing to bspwm node_add...

bspc subscribe node_add | while read line
do
  node_callback "$line"
done &

echo subscribing to bspwm node_remove...

bspc subscribe node_remove | while read line
do
  node_callback "$line"
done &

