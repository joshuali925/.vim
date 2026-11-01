# https://raw.githubusercontent.com/junegunn/fzf/HEAD/shell/key-bindings.bash
# commit: d282a1649d7d953f028306f13d6616958f3fd1f3

__fzf_cd_widget() {
  local dir
  dir=$(FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)) || return
  if [[ -n $READLINE_LINE ]]; then
    printf -v dir '%q ' "$dir"
    READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$dir${READLINE_LINE:READLINE_POINT}
    ((READLINE_POINT += ${#dir}))
    return 1
  fi
  if [[ -d $dir ]]; then cd -- "$dir"; else "$EDITOR" -- "$dir"; fi
  return 0
}
# customized: change fzf bindings to CTRL-P
bind -m emacs-standard -x '"\C-p": fzf-file-widget'
if [[ -n $NIU_PROMPT_SYMBOL ]]; then
  bind -m emacs-standard -x '"\ec": __fzf_cd_widget'
else
  __fzf_cd_readline() { if __fzf_cd_widget; then bind '"\C-x\C-a": accept-line'; else bind '"\C-x\C-a": redraw-current-line'; fi; }
  bind -m emacs-standard -x '"\C-x\C-c": __fzf_cd_readline'
  bind -m emacs-standard '"\ec": "\C-x\C-c\C-x\C-a"'
fi

source ~/.vim/config/fzf/fzf-simple-completion.sh
