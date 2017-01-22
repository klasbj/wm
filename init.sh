#!/bin/bash

BASEDIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"

export SESSIONDIR="$BASEDIR/session"

if [[ -e "$SESSIONDIR" ]]; then
  [[ -e "${SESSIONDIR}.old" ]] && rm -rf "${SESSIONDIR}.old"
  mv "$SESSIONDIR" "${SESSIONDIR}.old"
fi
mkdir "$SESSIONDIR"

#OLDPATH="$PATH"
export PATH="$BASEDIR/bin:$BASEDIR/pysb:$PATH"

$BASEDIR/statusbars/status.sh &> $SESSIONDIR/status.log &

#export PATH="$OLDPATH"

# Start compton
if hash compton &> /dev/null; then
  compton --config "${XDG_CONFIG_HOME:-"$HOME/.config"}/compton/compton.conf" -b
fi

# allow the socket to open
sleep 0.3

[[ -z "$BARSOCKET" ]] && BARSOCKET=$SESSIONDIR/dzen.socket
[[ -z "$DWMBIN" ]] && DWMBIN=$BASEDIR/dwm/dwm

#echo "add_area dwmws0 0 TOP 1000 CENTER
#add_area dwm1 1 TOP 1000 CENTER" | ncat -U "$BARSOCKET"
echo "add_area dwmws# -1 TOP 1000 LEFT dwm-ws
add_area dwmlt# -1 TOP 1000 LEFT_HL dwm-lt
add_area dwmtitle# -1 TOP 1000 CENTER_L
add_area clock -1 TOP 10000 RIGHT clock" | ncat -U "$BARSOCKET"

exec $DWMBIN 2> $SESSIONDIR/dwm.log | ncat -U "$BARSOCKET"
