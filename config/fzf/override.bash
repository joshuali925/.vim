# https://raw.githubusercontent.com/junegunn/fzf/HEAD/shell/key-bindings.bash
# commit: d282a1649d7d953f028306f13d6616958f3fd1f3

__fzf_cd__() {
  local opts dir
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse --walker=dir,follow,hidden --scheme=path ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} +m"
  # customized to allow editing files
  dir=$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS="$opts" $(__fzfcmd)
  ) && if [[ -d $dir ]]; then printf 'builtin cd -- %q' "$dir"; else printf '%q -- %q' "$EDITOR" "$dir"; fi
}
# customize fzf bindings to CTRL-P, and add space to ignore history for ALT-C
if (( BASH_VERSINFO[0] < 4 )); then
  bind -m emacs-standard '"\C-p": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
else
  bind -m emacs-standard -x '"\C-p": fzf-file-widget'
fi
bind -m emacs-standard '"\ec": " \C-b\C-k \C-u `__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

source ~/.vim/config/fzf/fzf-simple-completion.sh
