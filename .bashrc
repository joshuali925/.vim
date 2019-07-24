# .bashrc
# [ -t 1 ] && exec zsh

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

source ~/.vim/others/bashrc_wsl.sh
source ~/.vim/others/common.sh
source ~/.vim/others/git.sh

# Set bash prompt (\w for whole path, \W for current directory)
export PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
LS_COLORS=$LS_COLORS:'di=0;36'  # better ls directory color
stty -ixon  # disable Ctrl-S freeze
shopt -s autocd
shopt -s cdspell

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

alias ~='cd ~'
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'

# function cd { builtin cd $@ && ls -CF; }
function cd() {
    builtin cd $@
    ls -CF
    if [[ -z "$VIRTUAL_ENV" ]] ; then
        if [[ -f ./venv/bin/activate ]] ; then
            source ./venv/bin/activate
        fi
    else
        parentdir="$(dirname "$VIRTUAL_ENV")"
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            deactivate
        fi
    fi
}

# WSL specific
alias db='mycli -ukite -p123 -hlocalhost -P3306'
alias you-get='you-get -o /mnt/z/'
alias code='code . &'
alias cmd='/mnt/c/Windows/System32/cmd.exe /k'
