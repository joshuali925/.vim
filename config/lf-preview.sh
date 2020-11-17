#!/bin/sh
unset COLORTERM

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) zipinfo -1 "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    # *.pdf) pdftotext "$1" -;;
    *) bat --color=always --theme=OneHalfDark --plain "$1";;
esac
