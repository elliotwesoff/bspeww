#!/bin/sh
#
# bspeww.sh

# kill any prior running services
pkill --echo --full "^ruby\s+.*server\.rb"
pkill --echo --full "^bspc\s+subscribe(\s+node_(add|remove|transfer)){3,}"
pkill --echo --full "^bspc\s+subscribe\s+desktop_focus"

# subscribe to bspc node events
~/code/bspeww/scripts/bspwm-subscribe-nodes.sh

# start sinatra server. sinatra outputs to stderr by default,
# redirect stderr to a log file and send the process to the
# background.
ruby ~/code/bspeww/server.rb -p 3100 &> ~/.bspeww/server.log & disown

# dump current bspwm state
bspc wm -d > ~/.bspeww/bspwm-state.json

# wait for sinatra server to come online
while [ ! $(curl --silent http://localhost:3100/ping) ]
do
  sleep 1
done

# read and parse the current bspwm window states
curl http://localhost:3100/read

# write window states to disk for eww listeners
curl http://localhost:3100/write
