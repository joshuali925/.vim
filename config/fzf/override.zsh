# https://raw.githubusercontent.com/junegunn/fzf/HEAD/shell/key-bindings.zsh
# commit: d282a1649d7d953f028306f13d6616958f3fd1f3

# customized: ensure precmds are run after cd
fzf-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N fzf-redraw-prompt
# ALT-C - cd into the selected directory
fzf-cd-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --walker=dir,follow,hidden --scheme=path --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-}" $(__fzfcmd) +m < /dev/tty)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  # =======================================================
  # customized: to support editing files, and run cd command in zle
  if [[ -d $dir ]]; then
    builtin cd -- "$dir"
  else
    $EDITOR -- "$dir" < /dev/tty
  fi
  printf "\n\n"
  # =======================================================
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle fzf-redraw-prompt  # customized: use fzf-redraw-prompt instead of reset-prompt so prompt would update
  return $ret
}
# customized: change to ctrl-p
bindkey -M emacs '^P' fzf-file-widget
zinit depth=1 light-mode for Aloxaf/fzf-tab  # load fzf-tab after fzf/shell and before defining tab-complete-or-cd
# vim <tab>: files in current directory or args completion
# vim <C-p>: all files in current and subdirectories, respects .gitignore
# vim \<tab>: all files in current and subdirectories
tab-complete-or-cd() {
  if [[ -z $LBUFFER ]]; then
    zle fzf-cd-widget
  else
    zle fzf-tab-complete
    # zle fzf-completion  # zsh original tab complete
  fi
}
zle -N tab-complete-or-cd
bindkey '^i' tab-complete-or-cd
