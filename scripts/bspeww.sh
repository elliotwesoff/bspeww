#!/bin/sh
#
# bspeww.sh

# kill any prior running services
pkill --echo --full "^bspc\s+subscribe(\s+node_(add|remove|transfer)){3,}"
pkill --echo --full "^bspc\s+subscribe\s+desktop_focus"

# subscribe to bspc node events
~/code/bspeww/scripts/bspwm-subscribe-nodes.sh
