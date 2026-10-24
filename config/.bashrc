# shellcheck disable=1090,2059
# [[ -t 1 ]] && exec zsh

# interactive settings. [[ -t 1 ]] or [[ -n $PS1 ]] is somewhat faster, but niubash leaves PS1 unset in interactive mode
if [[ $- = *i* ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
     # shellcheck disable=1091
     # TODO change to -z BASH_COMPLETION_VERSINFO when it is always set by bash_completion to determine if it's already loaded
     [[ -z $BASH_COMPLETION_LOADED ]] && . /usr/share/bash-completion/bash_completion && BASH_COMPLETION_LOADED=1
     alias get-completion='complete -F _longopt'
  fi
  bind 'set show-all-if-ambiguous on'
  bind 'set completion-ignore-case on'
  bind 'set enable-bracketed-paste on'
  bind 'TAB: menu-complete'
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
  bind '"\eOA": history-search-backward'
  bind '"\eOB": history-search-forward'
  PROMPT_COMMAND=_set_prompt
  shopt -u promptvars  # PS1 embeds the branch name, which must not be expanded
  if [[ -n $NIU_PROMPT_SYMBOL ]]; then
    : "${HOSTNAME:=$COMPUTERNAME}"  # for niubash PS1 \h
    bind() {  # fzf's vendored key-bindings use readline functions niubash cannot mirror
      case "$*" in *redraw-current-line* | *editing-mode*) return 0 ;; esac
      builtin bind "$@"
    }
    _niu_yy_widget() { NIU_WIDGET_RESULT=yy; NIU_WIDGET_ACCEPT=1; }; NIU_BINDKEYS="Ctrl+O:_niu_yy_widget"  # bind -x hangs the prompt on windows
    _niu_report_cwd() {  # windows terminal's duplicate tab
      local p=$PWD
      case $p in /[A-Za-z]) p="${p:1:1}:/" ;; /[A-Za-z]/*) p="${p:1:1}:${p:2}" ;; esac
      printf '\e]9;9;%s\e\\' "${p//\//\\}"
    }
    PROMPT_COMMAND+='; _niu_report_cwd'
  else  # niubash's line editor rejects these sequences/functions
    bind '"\e[Z": menu-complete-backward'
    bind '"\C-g": edit-and-execute-command'
    bind '"\C-xa": shell-expand-line'  # same as in zsh, 'C-x a' expands aliases
    bind '"\e[1;5D": backward-word'
    bind '"\e[1;5C": forward-word'
    bind '"\e[3;2~": backward-delete-char'
    stty -ixon werase undef  # disable Ctrl-S freeze, unbind werase to C-w
    bind '"\C-w": unix-filename-rubout'
    # shellcheck disable=2016
    bind -x '"\C-o": "_old_pwd=$PWD; yy; [[ $_old_pwd != $PWD ]] && pwd"'  # somehow bind C-o will not trigger on mac. need pwd because using bind -x the prompt will not update. __fzf_cd__ style won't allow opening vim in yazi
  fi
  shopt -s autocd
  shopt -s cdspell
  shopt -s checkwinsize
  shopt -s dotglob

  if [[ -f ~/.vim/config/fzf/shell.bash ]]; then
    [[ -n $NIU_PROMPT_SYMBOL ]] && perl() { :; }  # niubash's fzf history does not use perl
    source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash
    if [[ -n $NIU_PROMPT_SYMBOL ]]; then
      unset -f perl
      __niu_fzf_cd() { local cmd; cmd=$(__fzf_cd__) && eval "$cmd"; }
      bind -x '"\ec": __niu_fzf_cd'  # fzf's Alt-C is a readline macro, which niubash inserts as literal text
      __niu_fzf_history() {
        local sel; sel=$(awk '{a[NR]=$0} END {for (i = NR; i > 0; i--) if (!seen[a[i]]++) print a[i]}' "$HOME/.niubash_history" | fzf --scheme=history --query "$READLINE_LINE") || return
        READLINE_LINE=$sel
        READLINE_POINT=${#READLINE_LINE}
      }
      bind -x '"\C-r": __niu_fzf_history'
    fi
  elif [[ -z $DOT_VIM_LOCAL_BIN ]]; then
    _load_fzf() { ~/.vim/bin/fzf --version >/dev/null && source ~/.vim/config/fzf/shell.bash && source ~/.vim/config/fzf/override.bash; }
    bind -x '"\ec": _load_fzf'
    bind -x '"\C-p": _load_fzf'
    bind -x '"\C-r": _load_fzf'
  fi

  # ref: https://gist.github.com/bingzhangdai/dd4e283a14290c079a76c4ba17f19d69
  _set_prompt() {
    local _exit=$? _dir=$PWD _head_file _head _git _status _char_color=32
    while [[ -n $_dir ]]; do
      if [[ -f $_dir/.git/HEAD ]]; then
        _head_file=$_dir/.git/HEAD
        break
      elif [[ -f $_dir/.git ]]; then
        read -r _head_file < "$_dir/.git" && _head_file=${_head_file#gitdir: }/HEAD
        if [[ ! -f $_head_file ]]; then _head_file=$_dir/$_head_file; fi
        break
      fi
      _dir=${_dir%/*}
    done
    if [[ -f $_head_file ]] && read -r _head < "$_head_file"; then
      case "$_head" in
        ref:*) _git=${_head#ref: refs/heads/} ;;
        *) _git=${_head:0:9} ;;  # HEAD detached
      esac
      _git=" \[\e[32m\] $_git"
    fi
    (( _exit )) && _status=" \[\e[31m\]✘ $_exit" _char_color=31
    PS1='\n\[\e[90m\]\u@\h \[\e[1;34m\]\w\[\e[22m\]'"$_git$_status"'\n\[\e['$_char_color'm\]❯\[\e[0m\] '
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
    if [[ -n $NIU_PROMPT_SYMBOL ]]; then local _oldpwd=$OLDPWD; builtin cd -- "$PWD"; OLDPWD=$_oldpwd; fi  # niubash bug
    local _entries=(*); if [[ ${#_entries[@]} -lt 200 ]]; then ls -AF --color=auto; fi
  }
  complete -d cd

  .vim-disable-prompt-command() {
    PS1="\n\[\e[90m\]\u@\h \[\e[1;34m\]\w\[\e[0m\]\n\$([[ \$? != 0 ]] && printf \"\[\e[31m\]\" || printf \"\[\e[32m\]\")❯ \[\e[0m\]"
    PROMPT_COMMAND=
    shopt -s promptvars
  }
  source ~/.vim/config/z.sh
fi

shopt -u expand_aliases
if [[ -n $NIU_PROMPT_SYMBOL ]]; then
  eval "$(< ~/.vim/config/common.sh)"  # niubash runs eval faster
  vf() { local fzftemp=($(FZF_DEFAULT_COMMAND= fzf --walker=file,follow,hidden  --walker-skip=.git,node_modules,.venv --multi)); if [[ -n $fzftemp ]]; then $EDITOR -- "${fzftemp[@]}"; fi; }
else
  source ~/.vim/config/common.sh
fi
shopt -s expand_aliases
HISTCONTROL=ignoreboth:erasedups:ignorespace
