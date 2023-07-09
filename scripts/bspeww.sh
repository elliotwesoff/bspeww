#!/bin/sh
#
# bspeww.sh

~/code/bspeww/scripts/bspwm-subscribe-nodes.sh
ruby ~/code/bspeww/server.rb -p 3100 &> ~/.bspeww/server.log &
bspc wm -d > ~/.bspeww/bspwm-state.json
sleep 3
curl --connect-timeout 30 --max-time 60 http://localhost:3100/ping
curl http://localhost:3100/read
curl http://localhost:3100/write
