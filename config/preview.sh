#!/bin/sh

tput smcup  # alternate screen
cleanup() { tput rmcup; }
trap cleanup TERM INT EXIT

pager() {
  [ -d "$1" ] && { printf "%s\n\n" "$1"; ls "$1" -AlhF --color=always; } | bat && return
  if [ "$(wc -c < "$1")" -gt 2097152 ]; then # 2MB
    less -RiNM "$1"
  else
    bat --color=always --style=numbers --paging=always "$1"
  fi
}

if file -Lb --mime-type -- "$1" | grep -qF image/; then
  iterm-imgcat "$1"; read _; echo
  exit 0
fi

case "$1" in
  *.tar|*.tar.gz|*.tar.xz|*.tar.bz2|*.tgz|*.xz|*.tbz|*.tbz2) tar tf "$1" | less -RiM ;;
  *.zip) zipinfo -1 "$1" | less -RiM ;;
  *.rar) unrar l "$1" | less -RiM ;;
  *.7z) 7z l -p "$1" | less -RiM ;;
  # *.pdf) pdftotext "$1" -;;
  *) pager "$1" ;;
esac
