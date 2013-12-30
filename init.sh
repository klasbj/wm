#!/bin/bash

BASEDIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"

export PATH="$BASEDIR/dzcoord/bin:$PATH"

echo "Loading statusbars" > $HOME/.log.load_statusbars
$BASEDIR/statusbars/load_statusbars &>> $HOME/.log.load_statusbars &

# allow the socket to open
sleep 0.3

[[ -z "$DWMSOCKET" ]] && DWMSOCKET=$BASEDIR/statusbars/dzen.socket
[[ -z "$DWMBIN" ]] && DWMBIN=$BASEDIR/dwm/dwm

echo "add_area dwm0 0 TOP 1000 CENTER
add_area dwm1 1 TOP 1000 CENTER" | ncat -U "$DWMSOCKET"

exec $DWMBIN 2> $HOME/.dwm.log | ncat -U "$DWMSOCKET"
