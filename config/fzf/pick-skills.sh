#!/usr/bin/env bash
set -euo pipefail

cache="$HOME/.claude/plugins/cache"
user_skills="$HOME/.claude/skills"
commands="$HOME/.vim/config/claude/commands"

{
  fd SKILL.md "$user_skills"
  fd -e md . "$commands"
  fd SKILL.md "$cache" --exec-batch stat -c '%Y %n'
} | awk -v cache="$cache/" -v user="$user_skills/" '
    function parse(path,   d, fm, cont, ln, line, v) {
      d = ""; fm = 0; cont = 0; ln = 0
      while ((getline line < path) > 0) {
        if (++ln > 40) break
        if (line ~ /^---[[:space:]]*$/) { fm++; if (fm == 2) break; continue }
        if (fm != 1) continue
        if (match(line, /^description:[[:space:]]*/)) {
          v = substr(line, RSTART + RLENGTH)
          sub(/^[>|][-+]?[[:space:]]*$/, "", v)
          d = v; cont = 1; continue
        }
        if (cont) {
          if (line ~ /^[a-zA-Z_][a-zA-Z0-9_-]*:/) { cont = 0; continue }
          sub(/^[[:space:]]+/, "", line)
          d = (d == "" ? line : d " " line)
        }
      }
      close(path)
      return d
    }
    {
      # Plugin cache lines carry a mtime prefix from stat; others are plain paths.
      if ($0 ~ /^[0-9]+ /) {
        ts = $1 + 0; path = substr($0, index($0, " ") + 1)
      } else {
        ts = 0; path = $0
      }

      if (index(path, cache) == 1) {
        rel = substr(path, length(cache) + 1)
        n = split(rel, p, "/")
        name = p[n-1]; key = p[2] ":" name; prio = 2
      } else if (index(path, user) == 1) {
        rel = substr(path, length(user) + 1)
        split(rel, p, "/"); name = p[1]; key = name; prio = 0
      } else {
        n = split(path, p, "/"); name = p[n]; sub(/\.md$/, "", name); key = name; prio = 1
      }

      # Skip localized skill variants except en, zh, zhs
      if (name ~ /-(ar|bg|bn|cs|da|de|el|es|et|fa|fi|fr|he|hi|hr|hu|id|it|ja|ko|lt|lv|ms|nl|no|pl|pt|ro|ru|sk|sl|sr|sv|ta|te|th|tr|uk|ur|vi|zht)$/) next

      # Prefer lower prio; within same prio (plugin cache only), prefer newest.
      if (!(name in seen) || prio < seen[name] || (prio == seen[name] && ts > mtime[name])) {
        seen[name] = prio; keyOf[name] = key; pathOf[name] = path; mtime[name] = ts
      }
    }
    END {
      for (n in pathOf) {
        desc = parse(pathOf[n])
        if (length(desc) > 161) desc = substr(desc, 1, 160) "…"
        printf "\033[1;36m%s\033[0m\n  \033[2m%s\033[0m\t%s%c", keyOf[n], desc, pathOf[n], 0
      }
    }' \
  | sort -z \
  | fzf --read0 --ansi --gap --wrap --wrap-sign='' \
        --delimiter='[\t\n]' --with-nth=1..2 --nth=1 \
        --preview='cat {3}' \
        --preview-window='bottom:99%,hidden' \
        --bind='ctrl-p:toggle-preview,,:preview-down,.:preview-up' \
        --bind='enter:become(printf "@%s " {+3} | xargs -I@ tmux send-keys -l @)'
