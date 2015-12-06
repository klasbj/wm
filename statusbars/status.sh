#!/bin/bash
#
# Set up the status bars
#

function _shutdown() {
  rm -f $SOCKET
  pkill -TERM -P $$
}

trap _shutdown INT TERM QUIT

[[ -z "$DEBUG_STATUSBAR" ]] && DEBUG_STATUSBAR=no

BASEDIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
IMAGEDIR="$BASEDIR/images"
SCRIPTDIR="$BASEDIR/scripts"
if [[ -z "$SESSIONDIR" ]]; then
  SESSIONDIR="$BASEDIR/session"
  if [[ -e "$SESSIONDIR" ]]; then
    [[ -e "${SESSIONDIR}.0" ]] && rm -rf "${SESSIONDIR}.0"
    mv "$SESSIONDIR" "${SESSIONDIR}.0"
  fi
  mkdir "$SESSIONDIR"
fi


SOCKET="$SESSIONDIR/dzen.socket"

debug() {
  if [[ -z "$1" ]]; then
    cat
  else
    tee -a "$@"
  fi
}

write() {
  echo "${@:2}" | debug "$1" | ncat -U "$SOCKET"
}

periodical() {
  true
  while [ $? -eq 0 ]
  do
    "${@:2}"
    sleep $1
  done
}

start() {
  local Exec
  local Type
  local Period
  local Area
  local Screen
  local Bar
  local Weight
  local Float
  source $1
  local processname=$(basename ${1})
  local dlog=$SESSIONDIR/${processname}.log
  if [[ "$DEBUG_STATUSBAR" != "yes" ]]; then
    unset dlog
  fi
  add=0
  for area in "${Area[@]}"; do
    write "${dlog}" "add_area ${area} ${Screen} ${Bar} $((Weight+add)) ${Float}"
    add=$((add+1))
  done

  case ${Type} in
    Periodical)
      Exec=(periodical ${Period} ${Exec[@]})
      ;;
    Continuous)
      ;;
    *)
      echo "Unkown type: ${Type}" >&2
      return 1
      ;;
  esac
  "${Exec[@]}" > >(debug ${dlog} | ncat -U "$SOCKET") &
  echo $! > $SESSIONDIR/${processname}.pid
  echo "${processname} started..."
}

stop() {
  local processname=$(basename ${1})
  echo "Stopping $processname"
  # write rm_area ${processname}
  kill $(cat $SESSIONDIR/${processname}.pid)
}


# Start the bar program
rm -f "$SOCKET"
debuglogfile="$SESSIONDIR/input.log"
if [[ "$DEBUG_STATUSBAR" != "yes" ]]; then
  unset debuglogfile
fi

bar() {
  pysb.py &> $SESSIONDIR/bar.log
}

ncat -Ulk "$SOCKET" > >(debug ${debuglogfile} | bar) &
COORDPID=$!
sleep 0.1

for f in "$BASEDIR/conf.d/"*; do
  if [ -x "$f" ]; then
    start "$f"
    STARTED=(${STARTED[@]} "$f")
  fi
done

wait

for f in "${STARTED[@]}"; do
  stop "$f"
done

kill $COORDPID

exit 0
