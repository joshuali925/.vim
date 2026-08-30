#!/usr/bin/env bash

set -uo pipefail
umask 077

current_pane=${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}
current_tab=${HERDR_ACTIVE_TAB_ID:-}
[[ -n ${HERDR_BIN_PATH:-} && -n $current_pane && -n $current_tab ]] || exit 1

socket_key=$(printf '%s' "${HERDR_SOCKET_PATH:-default}" | cksum)
socket_key=${socket_key%% *}
state_dir=${TMPDIR:-/tmp}/herdr-pane-marks-$UID
state_file=$state_dir/$socket_key

mkdir -p "$state_dir" || exit 1
exec 9<>"$state_file" || exit 1
if command -v flock >/dev/null; then flock -n 9; else lockf -s -t 0 9; fi || exit 0

notify() {
  exec 9>&-
  "$HERDR_BIN_PATH" notification show "$1" --body "$2" --position top-right >/dev/null 2>&1 || :
}

mark() {
  printf '%s\n' "$current_pane" >"$state_file" || exit 1
  notify "$@"
  exit
}

IFS= read -r marked_pane 2>/dev/null <"$state_file" || marked_pane=
if [[ -z $marked_pane ]]; then mark "Pane marked" "$current_pane · press prefix+m at the destination"; fi

details=$("$HERDR_BIN_PATH" pane get "$marked_pane" 2>/dev/null |
  jq -er '.result.pane | select(.pane_id and .tab_id) | [.pane_id, .tab_id] | @tsv' 2>/dev/null) || details=
IFS=$'\t' read -r marked_pane marked_tab <<<"$details"
if [[ -z $marked_pane || -z $marked_tab ]]; then mark "Pane re-marked" "The previous pane no longer exists; marked $current_pane"; fi

if [[ $marked_pane == "$current_pane" ]]; then
  : >"$state_file" || exit 1
  notify "Pane mark cleared" "$current_pane"
  exit
fi

if [[ $marked_tab == "$current_tab" ]]; then
  action=swap
  herdr_args=(pane swap --source-pane "$marked_pane" --target-pane "$current_pane")
else
  action=move
  herdr_args=(pane move "$marked_pane" --tab "$current_tab" --target-pane "$current_pane" --split down --focus)
fi

details=$("$HERDR_BIN_PATH" "${herdr_args[@]}" 2>/dev/null |
  jq -r '.result | (.swap // .move_result) | [(.changed // false), (.reason // .pane.pane_id // "unchanged")] | @tsv' 2>/dev/null) || details=
IFS=$'\t' read -r changed detail <<<"$details"
if [[ $changed != true ]]; then
  notify "Pane $action failed" "${detail:-Invalid response} · the mark is still active"
  exit 1
fi

: >"$state_file" || exit 1
if [[ $action == swap ]]; then notify "Panes swapped" "$marked_pane ↔ $current_pane"; else notify "Pane moved" "$detail · placed below $current_pane"; fi
