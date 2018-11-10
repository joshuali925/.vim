# .bashrc
# [ -t 1 ] && exec zsh

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

[[ -s ~/.autojump/etc/profile.d/autojump.sh  ]] && source ~/.autojump/etc/profile.d/autojump.sh

# Set bash prompt (\w for whole path, \W for current directory)
export PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
export PATH=$PATH:$HOME/.local/bin
LS_COLORS=$LS_COLORS:'di=0;36'

stty -ixon
shopt -s autocd
shopt -s cdspell

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

alias mkdir='mkdir -p'
alias ll='ls -AlhF'
alias la='ls -AF'
alias l='ls -CF'

alias vi='vim'
alias tmux='tmux -2'

alias ~='cd ~'
alias b='cd -'
alias ..='cd ..'
alias ...='cd ../..'

function f { find . -iname *$@*; }
function cc { gcc $1.c -o $1 -g && ./$@; }
function cd { builtin cd $@ && ls -ACF; }
