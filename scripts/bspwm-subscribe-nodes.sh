#!/bin/bash
#
# bspwm-subscribe-nodes.sh

node_callback() {
  echo $1 >> ~/tmp/bspeww/node-change.log
 
  bspc wm -d \
    | jq -c '.monitors[0].desktops[] | .root // {} | [.[] | recurse | select(.instanceName?) | .instanceName] | join("; ")' \
    | jq -c -s . \
    >> ~/tmp/bspeww/desktops/data
}

desktop_callback() {
  # parse the currently selected desktop node from wmtrl -d and write to disk.
  wmctrl -d | grep -F '*' | rev | cut -d ' ' -f 1 | rev >> ~/tmp/bspeww/desktops/selected
}

mkdir -p ~/tmp/bspeww/desktops

bspc subscribe node_add node_remove node_transfer | while read line
do
  node_callback "$line"
done &

bspc subscribe desktop_focus | while read line
do
  desktop_callback "$line"
done &
