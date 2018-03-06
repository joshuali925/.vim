# .bashrc
[ -t 1 ] && exec zsh

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
shopt -s autocd
shopt -s cdspell

alias ll='ls -AlF'
alias la='ls -AF'
alias l='ls -CF'
alias b='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

function f { find . -iname *$@*; }
function cc { gcc $1.c -o $1 -g && ./$@; }
function cd { builtin cd $@ && ls -CF; }
