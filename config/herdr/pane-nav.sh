#!/usr/bin/env bash

set -u

operation=${1-}
key=${2-}

case $operation in
  focus | resize) ;;
  *) exit 2 ;;
esac
case $key in
  h) direction=left ;;
  j) direction=down ;;
  k) direction=up ;;
  l) direction=right ;;
  *) exit 2 ;;
esac

pane_id=${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}
herdr_bin=${HERDR_BIN_PATH:-}
[[ -n $pane_id && -n $herdr_bin ]] || exit 1

process_info=$("$herdr_bin" pane process-info --pane "$pane_id" 2>/dev/null) || process_info=

if [[ $process_info =~ \"name\":\"g?(view|n?vim?x?)(diff)?\" ]]; then
  if [[ $operation == focus ]]; then modifier=ctrl; else modifier=alt; fi
  exec "$herdr_bin" pane send-keys "$pane_id" "$modifier+$key" >/dev/null
fi

exec "$herdr_bin" pane "$operation" --direction "$direction" --pane "$pane_id" >/dev/null
