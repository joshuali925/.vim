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
export PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
stty -ixon  # disable Ctrl-S freeze
shopt -s autocd
shopt -s cdspell

export HISTCONTROL="ignorespace"

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind '"\C-x\C-e": edit-and-execute-command'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# same as in zsh, 'C-x a' expands aliases
bind '"\C-xa": shell-expand-line'

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
  ls -ACF
}
complete -d cd

# WSL specific
alias cmd='/mnt/c/Windows/System32/cmd.exe /k'
