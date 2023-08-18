#!/bin/bash
#
# bspwm-subscribe-nodes.sh

node_callback() {
  echo $1 >> ~/tmp/bspeww/node-change.log
 
  curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data $(bspc wm -d) \
    http://localhost:3100/receive

  curl http://localhost:3100/write
}

desktop_callback() {
  # parse the currently selected desktop node from wmtrl -d and write to disk.
  wmctrl -d | grep -F '*' | rev | cut -d ' ' -f 1 | rev >> ~/tmp/bspeww/desktops/selected
}

mkdir -p ~/tmp/bspeww/desktops

bspc subscribe node_add node_remove node_transfer desktop_focus | while read line
do
  node_callback "$line"
done &

