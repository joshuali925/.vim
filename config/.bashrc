# shellcheck disable=1090,2015,2059,2148
# [[ -t 1 ]] && exec zsh

# shellcheck disable=1091
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && alias get-completion='complete -F _longopt' \
  && [[ -z $BASH_COMPLETION_VERSINFO ]] && . /usr/share/bash-completion/bash_completion

if [[ -f ~/.vim/config/fzf/shell.bash ]]; then
  source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash
elif [[ -z $DOT_VIM_LOCAL_BIN ]]; then
  _load_fzf() { ~/.vim/bin/fzf --version >/dev/null && source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash; }
  bind -x '"\ec": _load_fzf'
  bind -x '"\C-p": _load_fzf'
  bind -x '"\C-r": _load_fzf'
fi

source ~/.vim/config/common.sh

# Set bash prompt (\w for whole path, \W for current directory)
PS1='\n\[\e[38;5;178m\][\u@\h] \[\e[38;5;208m\]\w$(_get_prompt_tail "\n")'
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s dotglob
shopt -s no_empty_cmd_completion

HISTCONTROL=ignoreboth:erasedups:ignorespace

__lf_cd__() {
  local dir
  dir="$(command lf -print-last-dir)" && if [[ -n "$dir" && "$dir" != "$PWD" ]]; then printf 'builtin cd -- %q' "$dir"; fi
}

# interactive settings. it's better to check interactive with [[ $- = *i* ]], but [[ -t 1 ]] is somewhat faster
if [[ -t 1 ]]; then
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
  if [[ $OSTYPE = darwin* ]]; then
    bind -x '"\C-o": "lf; pwd"'  # somehow bind C-o will not trigger on mac. using bind -x the prompt will not update
  else
    bind '"\er": redraw-current-line'
    bind '"\C-o": " \C-b\C-k \C-u `__lf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
  fi
  stty -ixon  # disable Ctrl-S freeze
  stty werase undef  # unbind werase to C-w
  bind '"\C-w": unix-filename-rubout'

  # tab to complete command or use fzf to change directory, incompatible with ble.sh
  if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then  # bash >= 4.0 needed for $READLINE_LINE
    BINDED_COMPLETION=-1
    _check_tab_complete() {
      if [[ -n $READLINE_LINE ]]; then
        bind '"\301": menu-complete'
        bind 'TAB: menu-complete'
        BINDED_COMPLETION=1
      fi
    }
    _reset_tab() {
      if [[ $BINDED_COMPLETION != 0 ]]; then
        bind '"\301": "\ec"'
        bind 'TAB: "\300\301"'
        BINDED_COMPLETION=0
      fi
    }
    bind -x '"\300": _check_tab_complete'
    PROMPT_COMMAND="_reset_tab; $PROMPT_COMMAND"

    # bind -x breaks stdout without \n and multi-line prompt on some bash versions
    READLINE_LINE_TEMP=()
    READLINE_POINT_TEMP=()
    _push_line() {
      READLINE_LINE_TEMP+=("$READLINE_LINE")
      READLINE_POINT_TEMP+=("$READLINE_POINT")
      READLINE_LINE=
      bind '"\C-m": "\365\366"'
    }
    _restore_pushed_line() {
      # shellcheck disable=2124
      READLINE_LINE="${READLINE_LINE_TEMP[@]: -1}"
      # shellcheck disable=2124
      READLINE_POINT="${READLINE_POINT_TEMP[@]: -1}"
      unset 'READLINE_LINE_TEMP[${#READLINE_LINE_TEMP[@]}-1]'
      unset 'READLINE_POINT_TEMP[${#READLINE_POINT_TEMP[@]}-1]'
      if [[ ${#READLINE_LINE_TEMP[@]} -eq 0 ]]; then
        bind '"\C-m": accept-line'
      fi
    }
    bind '"\365": accept-line'
    bind -x '"\366": _restore_pushed_line'
    bind -x '"\eq": _push_line'
    bind -x '"\C-q": _push_line'
  fi
fi

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

_get_prompt_tail() {
  # https://gist.github.com/bingzhangdai/dd4e283a14290c079a76c4ba17f19d69
  # git branch with prompt sign colored by exit code
  # takes optional arguments as separators between those two
  local _head_file _head _dir="$PWD" _tail _exit="$?"
  [[ $_exit != 0 ]] && _tail="${*:- }"$'\001\e[38;5;9m\002$\001\e[0m\002 ' || _tail="${*:- }"$'\001\e[38;5;141m\002$\001\e[0m\002 '
  while [[ -n $_dir ]]; do
    _head_file="$_dir/.git/HEAD"
    if [[ -f $_dir/.git ]]; then
      read -r _head_file < "$_dir/.git" && _head_file="${_head_file#gitdir: }/HEAD"
      [[ ! -e $_head_file ]] && _head_file="$_dir/$_head_file" || break
    fi
    [[ -e $_head_file ]] && break
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

.vim-disable-prompt-command() {
  PS1="\n\[\e[38;5;178m\][\u@\h] \[\e[38;5;208m\]\w\n\$([[ \$? != 0 ]] && printf \"\[\e[38;5;9m\]\" || printf \"\[\e[38;5;141m\]\")$ \[\e[0m\]"
  PROMPT_COMMAND=
}
