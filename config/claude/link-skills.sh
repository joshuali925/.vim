#!/usr/bin/env bash

src="$HOME/.vim/config/claude/skills"
dest="$HOME/.claude/skills"
mkdir -p "$dest"
for link in "$dest"/*; do
  if [[ -L $link && ! -e $link && $(readlink "$link") = *.vim/config/claude/skills/* ]]; then rm "$link"; fi
done
for skill in "$src"/*/; do
  skill=${skill%/}
  if [[ ! -e $dest/${skill##*/} ]]; then ln -s "$skill" "$dest/${skill##*/}"; fi
done
