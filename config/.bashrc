# shellcheck disable=1090,2059
# [[ -t 1 ]] && exec zsh

# interactive settings. it's better to check with [[ $- = *i* ]], but [[ -t 1 ]] or [[ -n $PS1 ]] is somewhat faster
if [[ -n $PS1 ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
     # shellcheck disable=1091
     # TODO change to -z BASH_COMPLETION_VERSINFO when it is always set
     [[ -z $BASH_COMPLETION_LOADED ]] && . /usr/share/bash-completion/bash_completion && BASH_COMPLETION_LOADED=1
     alias get-completion='complete -F _longopt'
  fi
  bind 'set show-all-if-ambiguous on'
  bind 'set completion-ignore-case on'
  bind 'set enable-bracketed-paste on'
  bind 'TAB: menu-complete'
  bind '"\e[Z": menu-complete-backward'
  bind '"\C-x\C-e": edit-and-execute-command'
  bind '"\C-xa": shell-expand-line'  # same as in zsh, 'C-x a' expands aliases
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
  bind '"\eOA": history-search-backward'
  bind '"\eOB": history-search-forward'
  bind '"\e[1;5D": backward-word'
  bind '"\e[1;5C": forward-word'
  bind '"\e[3;2~": backward-delete-char'
  # shellcheck disable=2016
  bind -x '"\C-o": "_old_pwd=$PWD; yy; [[ $_old_pwd != $PWD ]] && pwd"'  # somehow bind C-o will not trigger on mac. need pwd because using bind -x the prompt will not update. __fzf_cd__ style won't allow opening vim in yazi
  stty -ixon  # disable Ctrl-S freeze
  stty werase undef  # unbind werase to C-w
  bind '"\C-w": unix-filename-rubout'
  # Set bash prompt (\w for whole path, \W for current directory)
  PS1='\n\[\e[38;5;178m\][\u@\h] \[\e[38;5;208m\]\w$(_get_prompt_tail "\n")'
  shopt -s autocd
  shopt -s cdspell
  shopt -s checkwinsize
  shopt -s dotglob

  if [[ -f ~/.vim/config/fzf/shell.bash ]]; then
    source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash
  elif [[ -z $DOT_VIM_LOCAL_BIN ]]; then
    _load_fzf() { ~/.vim/bin/fzf --version >/dev/null && source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash; }
    bind -x '"\ec": _load_fzf'
    bind -x '"\C-p": _load_fzf'
    bind -x '"\C-r": _load_fzf'
  fi

  _get_prompt_tail() {
    # https://gist.github.com/bingzhangdai/dd4e283a14290c079a76c4ba17f19d69
    # git branch with prompt sign colored by exit code
    # takes optional arguments as separators between those two
    local _head_file _head _dir="$PWD" _tail _exit="$?"
    [[ $_exit != 0 ]] && _tail="${*:- }"$'\001\e[38;5;9m\002❯\001\e[0m\002 ' || _tail="${*:- }"$'\001\e[38;5;141m\002❯\001\e[0m\002 '
    while [[ -n $_dir ]]; do
      _head_file="$_dir/.git/HEAD"
      if [[ -f $_dir/.git ]]; then
        read -r _head_file < "$_dir/.git" && _head_file="${_head_file#gitdir: }/HEAD"
        if [[ ! -e $_head_file ]]; then _head_file="$_dir/$_head_file"; else break; fi
      fi
      if [[ -e $_head_file ]]; then break; fi
      _dir="${_dir%/*}"
    done
    if [[ -e $_head_file ]]; then
      read -r _head < "$_head_file" || return
      case "$_head" in
        ref:*) printf $'\001\e[38;5;130m\002'" (${_head#ref: refs/heads/})$_tail" ;;
        "") ;;
        # HEAD detached
        *) printf $'\001\e[38;5;130m\002'" (${_head:0:9})$_tail" ;;
      esac
    else
      printf "$_tail"
    fi
  }

  cd() {
    if [[ -z $1 ]]; then
      pushd "$HOME" > /dev/null || return
    elif [[ $1 = "-" ]]; then
      builtin cd "$OLDPWD" > /dev/null || return
    elif [[ $1 =~ ^-[0-9]+$ ]]; then
      pushd "+${1/-/}" > /dev/null || return
    else
      pushd "$@" > /dev/null || return
    fi
    if [[ $(command ls | wc -l) -lt 200 ]]; then ls -AF --color=auto; fi
  }
  complete -d cd

  .vim-disable-prompt-command() {
    PS1="\n\[\e[38;5;178m\][\u@\h] \[\e[38;5;208m\]\w\n\$([[ \$? != 0 ]] && printf \"\[\e[38;5;9m\]\" || printf \"\[\e[38;5;141m\]\")❯ \[\e[0m\]"
    PROMPT_COMMAND=
  }
fi

source ~/.vim/config/common.sh
HISTCONTROL=ignoreboth:erasedups:ignorespace
