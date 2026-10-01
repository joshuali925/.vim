#!/usr/bin/env bash

set -euo pipefail

pane_id=${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}
[[ -n $pane_id && -n ${HERDR_SOCKET_PATH:-} ]] || exit 1

request() { printf '%s\n' "$1" | nc -U "$HERDR_SOCKET_PATH" | jq -ce '.result // error(.error.message)'; }

request "$(jq -nc --arg pane_id "$pane_id" '{id:"key:even:export",method:"layout.export",params:{pane_id:$pane_id}}')" |
jq -rc --arg pane_id "$pane_id" '
  def span($direction):
    if .direction == $direction then (.first | span($direction)) + (.second | span($direction)) else 1 end;

  def balance($path; $direction):
    if .direction == $direction then
      (.first | span($direction)) as $first |
      ($first / ($first + (.second | span($direction))) | [., 0.1] | max | [., 0.9] | min) as $ratio |
      (select((.ratio - $ratio | fabs) > 0.000001) | {path:$path, ratio:$ratio}),
      (.first | balance($path + [false]; $direction)),
      (.second | balance($path + [true]; $direction))
    else empty end;

  .layout |
  (if .zoomed then {id:"key:even:zoom",method:"pane.zoom",params:{pane_id:$pane_id,mode:"off"}} else empty end),
  (
    .tab_id as $tab_id | .root as $root |
    ($root | path(.. | objects | select(.type == "pane" and .pane_id == $pane_id))) as $leaf |
    first(range(($leaf | length) - 1; -1; -1) | $leaf[:.] as $path |
      [$root | getpath($path) |
       select($path == [] or .direction != ($root | getpath($path[:-1])).direction) |
       balance($path | map(. == "second"); .direction)] | select(length > 0)
    )[] |
    {id:"key:even:ratio",method:"layout.set_split_ratio",params:({tab_id:$tab_id} + .)}
  )
' | while IFS= read -r payload; do request "$payload" >/dev/null; done
