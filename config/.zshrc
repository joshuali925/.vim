if [[ -n $ZSHRC_INIT ]]; then return; fi
ZSHRC_INIT=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  git clone https://github.com/zdharma-continuum/zinit --depth=1 ~/.zinit/bin && ZINIT_POST_INSTALL=1
fi
source ~/.zinit/bin/zinit.zsh

if [[ -n $ZINIT_POST_INSTALL ]]; then
  # to install completions generated by binary, use `<bin> completion zsh > "${fpath[1]}/_<bin>"`
  zinit --depth=1 light-mode for zsh-users/zsh-completions
  zinit as"completion" for \
    https://github.com/sharkdp/fd/blob/master/contrib/completion/_fd \
    https://github.com/asdf-vm/asdf/blob/master/completions/_asdf \
    https://github.com/gradle/gradle-completion/blob/master/_gradle \
    https://github.com/gradle/gradle-completion/blob/master/gradle-completion.plugin.zsh
fi

zinit depth=1 light-mode for atclone"$HOME/.zinit/plugins/romkatv---powerlevel10k/gitstatus/install" romkatv/powerlevel10k
zinit depth=1 wait"0" lucid light-mode for \
  as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" tj/git-extras \
  atload"FAST_HIGHLIGHT[chroma-git]='chroma/-ogit.ch'\
  FAST_HIGHLIGHT[chroma-man]=" \
  atclone"zsh -c 'source $HOME/.zinit/plugins/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme base16'" \
  zdharma-continuum/fast-syntax-highlighting

zinit depth=1 light-mode for \
  atload"!_zsh_autosuggest_start; \
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'; \
  ZSH_AUTOSUGGEST_STRATEGY=(history completion); \
  ZSH_AUTOSUGGEST_HISTORY_IGNORE=\"?(#c150,)\"; \
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50; \
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(up-line-or-beginning-search down-line-or-beginning-search); \
  ZSH_AUTOSUGGEST_MANUAL_REBIND=1; \
  ZSH_AUTOSUGGEST_USE_ASYNC=1" \
  zsh-users/zsh-autosuggestions

zinit snippet OMZ::lib/key-bindings.zsh
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

autoload -Uz compinit && compinit -u
zinit cdreplay -q

typeset -U path PATH
WORDCHARS=${WORDCHARS/\/}
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
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -AF --color=always -1 $realpath'
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 50 8

compdef _dirs d
compdef _command_names path
compdef _git gc=git-commit

bracketed-paste() {
  zle .$WIDGET && LBUFFER=${LBUFFER%$'\n'}
}
zle -N bracketed-paste  # remove trailing new line in bracketed paste

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

run-lf () {
  local dir precmd
  dir="$(command lf -print-last-dir < /dev/tty)" && if [[ -n "$dir" && "$dir" != "$PWD" ]]; then cd -- "$dir" > /dev/null; fi
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N run-lf

bindkey '^o' run-lf
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[H' beginning-of-line              # after exiting vim or lf started by zle,
bindkey '^[[F' end-of-line                    # ^[OA (defined in oh-my-zsh keybindings) becomes ^[[A
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;2A' up-line-or-local-history    # <S-Up>
bindkey '^[[1;2B' down-line-or-local-history  # <S-Down>
bindkey '^[[3;2~' backward-delete-char        # <S-Del>
bindkey '^[q' push-line-or-edit
bindkey '^q' push-line-or-edit
bindkey '^u' backward-kill-line
bindkey -s '^z' '%^m'
bindkey '\el' forward-char                    # unbind <Esc>l = ls from oh-my-zsh key-bindings
bindkey '^[[1;5C' emacs-forward-word          # <C-Right> to next word end. https://github.com/marlonrichert/zsh-edit seems incompatible with zinit

alias history='history -f 0'
alias get-completion='compdef _gnu_generic'
chpwd() { emulate -L zsh; [[ $(command ls | wc -l) -lt 200 ]] && ls -AF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.vim/config/.p10k.zsh.
source ~/.vim/config/.p10k.zsh

# prompt_user() {
#   p10k segment -f 208 -i '⭐' -t "$USER"
# }
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=user
