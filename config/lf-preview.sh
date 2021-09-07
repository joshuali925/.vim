#!/bin/sh
unset COLORTERM

pager() {
    local FSIZE=$(wc -c < "$1")
    if [ $FSIZE -gt 2097152 ]; then  # 2MB
        less --RAW-CONTROL-CHARS --ignore-case --LONG-PROMPT "$1"
    else
        bat --color=always --theme=OneHalfDark --plain "$1"
    fi
}

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) zipinfo -1 "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    # *.pdf) pdftotext "$1" -;;
    *) pager "$1";;
esac
