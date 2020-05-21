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

source ~/.vim/config/common.sh

# Set bash prompt (\w for whole path, \W for current directory)
export PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
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

function cd { builtin cd $@ && ls -CF; }
# function cd() {
#     builtin cd $@
#     ls -CF
#     if [[ -z "$VIRTUAL_ENV" ]] ; then
#         if [[ -f ./venv/bin/activate ]] ; then
#             source ./venv/bin/activate
#         fi
#     else
#         parentdir="$(dirname "$VIRTUAL_ENV")"
#         if [[ "$PWD"/ != "$parentdir"/* ]] ; then
#             deactivate
#         fi
#     fi
# }

# WSL specific
alias cmd='/mnt/c/Windows/System32/cmd.exe /k'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
