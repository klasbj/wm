#!/bin/bash

BASEDIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"

export PATH="$BASEDIR/dzcoord/bin:$PATH"
export SESSIONDIR="$BASEDIR/session"

if [[ -e "$SESSIONDIR" ]]; then
  [[ -e "${SESSIONDIR}.old" ]] && rm -rf "${SESSIONDIR}.old"
  mv "$SESSIONDIR" "${SESSIONDIR}.old"
fi
mkdir "$SESSIONDIR"

$BASEDIR/statusbars/status.sh &> $SESSIONDIR/status.log &

# allow the socket to open
sleep 0.3

[[ -z "$DWMSOCKET" ]] && DWMSOCKET=$SESSIONDIR/dzen.socket
[[ -z "$DWMBIN" ]] && DWMBIN=$BASEDIR/dwm/dwm

echo "add_area dwm0 0 TOP 1000 CENTER
add_area dwm1 1 TOP 1000 CENTER" | ncat -U "$DWMSOCKET"

exec $DWMBIN 2> $SESSIONDIR/dwm.log | ncat -U "$DWMSOCKET"
