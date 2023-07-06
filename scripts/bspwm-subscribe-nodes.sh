#!/bin/bash
#
# bspwm-subscribe-nodes.sh

node_callback() {
  echo $1 >> ~/.bspeww/node-change.log
  bspc wm -d > ~/.bspeww/bspwm-state.json
  curl http://localhost:3100/read
}

mkdir -p ~/.bspeww

bspc subscribe node_add | while read line
do
  node_callback "$line"
done &

bspc subscribe node_remove | while read line
do
  node_callback "$line"
done &

