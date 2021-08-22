# .bashrc
# [ -t 1 ] && exec zsh

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
  . /usr/share/bash-completion/bash_completion

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

source ~/.vim/config/fzf/completion.bash
source ~/.vim/config/fzf/key-bindings.bash

source ~/.vim/config/common.sh

# Set bash prompt (\w for whole path, \W for current directory)
PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
stty -ixon  # disable Ctrl-S freeze
shopt -s autocd
shopt -s cdspell

HISTCONTROL=ignoreboth:erasedups:ignorespace

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB: menu-complete'
bind '"\e[Z":menu-complete-backward'
bind '"\C-x\C-e": edit-and-execute-command'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'
bind -x '"\C-o":"lf"'

# same as in zsh, 'C-x a' expands aliases
bind '"\C-xa": shell-expand-line'

stty werase undef # unbind werase to C-w
bind '\C-w:unix-filename-rubout'

if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
  # bash >= 4.0 needed for $READLINE_LINE
  # NOTE this breaks multi-line prompt on bash 4.0 and output without \n
  BINDED_COMPLETION=-1
  _check_tab_complete() {
    if [ -n "$READLINE_LINE" ]; then
      bind '"\301": menu-complete'
      bind 'TAB: menu-complete'
      BINDED_COMPLETION=1
    fi
  }
  _reset_tab() {
    if [ $BINDED_COMPLETION != 0 ]; then
      bind '"\301": "\ec"'
      bind 'TAB: "\300\301"'
      BINDED_COMPLETION=0
    fi
  }
  _reset_tab
  bind -x '"\300": _check_tab_complete' # \300: set tab action based on user input, \301 triggers the action, TAB runs them together
  bind -x '"\365": _reset_tab'          # \365: reset tab binding, triggered on <CR>
  bind '"\366": accept-line'            # \366: previously bound to <CR>
  bind '"\C-m": "\365\366"'             # <CR>: reset tab binding and accept-line
fi

cd() {
  if [ "$1" == "" ]; then
    pushd "$HOME" > /dev/null
  elif [ "$1" == "-" ]; then
    builtin cd "$OLDPWD" > /dev/null
  elif [[ "$1" =~ ^-[0-9]+$ ]]; then
    pushd +${1/-/} > /dev/null
  elif [ "$1" == "--" ]; then
    shift
    pushd -- "$@" > /dev/null
  else
    pushd "$@" > /dev/null
  fi
  ls -ACF --color=auto
}
complete -d cd

# WSL specific
alias cmd='/mnt/c/Windows/System32/cmd.exe /k'
