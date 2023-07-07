#!/bin/sh
#
# bspeww.sh

~/code/bspeww/scripts/bspwm-subscribe-nodes.sh
ruby ~/code/bspeww/server.rb -p 3100 &> ~/.bspeww/server.log &
sleep 3
curl http://localhost:3100/read
