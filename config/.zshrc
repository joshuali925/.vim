# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && command git clone https://github.com/zdharma/zinit ~/.zinit/bin
source ~/.zinit/bin/zinit.zsh

zinit depth=1 light-mode for romkatv/powerlevel10k

zinit as"completion" for \
    https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd \
    https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg

zinit light-mode for \
    atload"FAST_HIGHLIGHT[chroma-git]='chroma/-ogit.ch'\
    FAST_HIGHLIGHT[chroma-man]=" \
    zdharma/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start; \
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'; \
    ZSH_AUTOSUGGEST_STRATEGY=(history completion); \
    ZSH_AUTOSUGGEST_HISTORY_IGNORE=\"?(#c150,)\"; \
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(up-line-or-beginning-search down-line-or-beginning-search); \
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1; \
    ZSH_AUTOSUGGEST_USE_ASYNC=1" \
    zsh-users/zsh-autosuggestions

source ~/.vim/config/oh-my-zsh-key-bindings.zsh
source ~/.vim/config/fzf/completion.zsh
source ~/.vim/config/fzf/key-bindings.zsh

source ~/.vim/config/common.sh

zpcompinit
# autoload -U compinit && compinit -u
# [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]] && compinit; zinit cdreplay -q
# autoload -U colors && colors

WORDCHARS=${WORDCHARS/\/}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

[[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE  # fix wsl bug
unsetopt no_match
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
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify

zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias history='builtin fc -l 1'

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^x^w' push-line-or-edit

compdef _dirs d
function chpwd() { emulate -L zsh; ls -ACF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.vim/config/.p10k.zsh ]] || source ~/.vim/config/.p10k.zsh
