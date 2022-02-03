#!/bin/sh
unset COLORTERM

pager() {
  [ -d "$1" ] && echo "$1" && ls "$1" -AlhF --color=always && return
  if [ "$(wc -c < "$1")" -gt 2097152 ]; then # 2MB
    less "$1"
  else
    bat --color=always --theme=OneHalfDark --plain "$1"
  fi
}

case "$1" in
  *.tar*) tar tf "$1" ;;
  *.zip) zipinfo -1 "$1" ;;
  *.rar) unrar l "$1" ;;
  *.7z) 7z l "$1" ;;
  # *.pdf) pdftotext "$1" -;;
  *) pager "$1" ;;
esac
