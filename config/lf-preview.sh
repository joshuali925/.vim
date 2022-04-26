#!/bin/sh
unset COLORTERM
[ -z "$FULL_PREVIEW" ] && BAT_OPTS='--plain --line-range :150' || BAT_OPTS='--style=numbers --paging=always'

pager() {
  [ -d "$1" ] && echo "$1" && ls "$1" -AlhF --color=always && return
  if [ "$(wc -c < "$1")" -gt 2097152 ]; then # 2MB
    less -RiM "$1"
  else
    bat --color=always --theme=OneHalfDark $BAT_OPTS "$1"
  fi
}

if [ -n "$FULL_PREVIEW" ] && [ "$(file -Lb --mime-type -- "$1" | cut -d/ -f1)" = image ]; then
  if [ -n "$TMUX" ]; then
    printf 'Press enter to copy print image command and detach tmux'; read; echo
    echo " iterm-imgcat '$(realpath "$1")'; printf 'Press enter to continue'; read; echo; tmux attach" | y && tmux detach
  else
    iterm-imgcat "$1"; printf 'Press enter to continue'; read; echo
  fi
  exit "$?"
fi

case "$1" in
  *.tar*|*.tgz|*.xz|*.tbz|*.tbz2) tar tf "$1" ;;
  *.zip) zipinfo -1 "$1" ;;
  *.rar) unrar l "$1" ;;
  *.7z) 7z l "$1" ;;
  # *.pdf) pdftotext "$1" -;;
  *) pager "$1" ;;
esac
