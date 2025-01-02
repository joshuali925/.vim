if [[ -n $ZSHRC_INIT ]]; then return; fi
ZSHRC_INIT=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=(~/.vim/config/zsh/completions $fpath)
zstyle ':zim:zmodule' use 'degit'
ZDOTDIR=~/.vim/config/zsh
ZIM_HOME=~/.local/zim

if [[ ! -e $ZIM_HOME/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o $ZIM_HOME/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! $ZIM_HOME/init.zsh -nt $ZDOTDIR/.zimrc ]]; then
  source $ZIM_HOME/zimfw.zsh init
  if [[ $OSTYPE = linux-android ]]; then  # https://github.com/zimfw/zimfw/issues/482#issuecomment-1288943906
    sed -i 's/#\?setopt NO_CASE_GLOB/#setopt NO_CASE_GLOB/' $ZIM_HOME/modules/completion/init.zsh
  fi
fi
source $ZIM_HOME/init.zsh

if [[ -f ~/.vim/config/fzf/shell.zsh ]]; then
  source ~/.vim/config/fzf/shell.zsh && source ~/.vim/config/fzf/override.zsh
elif [[ -z $DOT_VIM_LOCAL_BIN ]]; then
  load-fzf() {
    bindkey -r '^i'; bindkey -r '^r'; bindkey -r '^p'
    ~/.vim/bin/fzf --version >/dev/null && source ~/.vim/config/fzf/shell.zsh && source ~/.vim/config/fzf/override.zsh
  }
  load-fzf-c-i() { load-fzf && zle tab-complete-or-cd; } && zle -N load-fzf-c-i
  load-fzf-c-r() { load-fzf && zle fzf-history-widget; } && zle -N load-fzf-c-r
  load-fzf-c-p() { load-fzf && zle fzf-file-widget; } && zle -N load-fzf-c-p
  bindkey '^i' load-fzf-c-i
  bindkey '^r' load-fzf-c-r
  bindkey '^p' load-fzf-c-p
fi

source ~/.vim/config/common.sh
# TODO validate after v0.16.0 releases. ref: https://github.com/ohmyzsh/ohmyzsh/blob/d82669199b5d900b50fd06dd3518c277f0def869/plugins/asdf/asdf.plugin.zsh#L25
if [[ -e ~/.asdf/internal/completions/asdf.zsh ]]; then source ~/.asdf/internal/completions/asdf.zsh; fi

# show timestamp of command in history, not fully accurate due to grep -F containing partial matches. another slower solution: https://github.com/junegunn/fzf/issues/1049#issuecomment-2241522977
export FZF_CTRL_R_OPTS="--bind='\`:toggle-sort,ctrl-t:unbind(change)+track-current,ctrl-y:execute-silent(echo -n {2..} | y)+abort' --header='Press \` to toggle sort, C-t C-u to show surrounding items, C-y to copy' --preview='{ tac ~/.zsh_history | grep -m 1 -F {2..} | awk -F: \"{print \\\$2}\" | xargs -I= date -u +%Y-%m-%dT%H:%M:%SZ -d @=; echo ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈; echo {2..}; } | bat --language=bash --color=always --plain' --preview-window='wrap,40%'"

typeset -U path PATH
WORDCHARS=${WORDCHARS/=\/}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

unsetopt flow_control  # man zshoptions; man zshbuiltins; man zshall
unsetopt nomatch
setopt glob_dots
setopt complete_in_word
setopt always_to_end
setopt list_packed
setopt interactive_comments

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus

setopt extended_history
setopt share_history
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify

zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:git-checkout:*' sort false
zstyle -d ':completion:*' format  # https://github.com/Aloxaf/fzf-tab/issues/24
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -AF --color=always -1 $realpath'
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 50 8
zstyle ':fzf-tab:*' fzf-min-height 8
zstyle ':fzf-tab:*' use-fzf-default-opts yes

compdef _dirs d
compdef _command_names path
compdef _git gds=git-diff
compdef _git gc=git-commit
_git-wt() { _git-worktree; }
_git-preview-merge-diff() { _git-diff; }
_git-missing() { _git-log; }
_git-forest() { _git-log; }

bracketed-paste() {
  zle .$WIDGET && LBUFFER=${LBUFFER%$'\n'}
}
zle -N bracketed-paste  # remove trailing new line in bracketed paste

copy-line() {
  echo -n $BUFFER | y
}
zle -N copy-line

up-line-or-local-history() {
  zle set-local-history 1
  zle up-line-or-history
  zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
  zle set-local-history 1
  zle down-line-or-history
  zle set-local-history 0
}
zle -N down-line-or-local-history

run-file-manager () {
  local precmd tmp="$(mktemp -t "yazi-cwd.XXXXXX")" dir
  yazi "$@" --cwd-file="$tmp" < /dev/tty
  if dir="$(cat -- "$tmp")" && [[ -n "$dir" && "$dir" != "$PWD" ]]; then cd -- "$dir" > /dev/null; fi
  rm -f -- "$tmp"
  for precmd in $precmd_functions; do $precmd; done
  zle reset-prompt
}
zle -N run-file-manager

bindkey '^o' run-file-manager
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[H' beginning-of-line              # after exiting vim started by zle,
bindkey '^[[F' end-of-line                    # ^[OA (defined in oh-my-zsh keybindings) becomes ^[[A
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;2A' up-line-or-local-history    # <S-Up>
bindkey '^[[1;2B' down-line-or-local-history  # <S-Down>
bindkey '^[[3;2~' backward-delete-char        # <S-Del>
bindkey '^[q' push-line-or-edit
bindkey '^q' push-line-or-edit
bindkey '^u' backward-kill-line
bindkey '^x^y' copy-line
bindkey -s '^z' '%^m'
bindkey '\el' forward-char                    # unbind <Esc>l = ls from oh-my-zsh key-bindings
bindkey '^[[1;5C' emacs-forward-word          # <C-Right> to next word end. alternative: https://github.com/marlonrichert/zsh-edit

alias history='history -f 0'
alias get-completion='compdef _gnu_generic'
chpwd() { emulate -L zsh; [[ $(command ls | wc -l) -lt 200 ]] && ls -AF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.vim/config/zsh/.p10k.zsh.
source ~/.vim/config/zsh/.p10k.zsh

# prompt_user() {
#   p10k segment -f 208 -i '⭐' -t "$USER"
# }
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=user
