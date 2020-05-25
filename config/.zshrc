# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -U colors && colors
[[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE  # fix wsl bug

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && command git clone https://github.com/zdharma/zinit ~/.zinit/bin
source ~/.zinit/bin/zinit.zsh

zinit wait lucid for \
    hlissner/zsh-autopair \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    atload"FAST_HIGHLIGHT[chroma-git]='chroma/-ogit.ch'" \
    zdharma/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start; \
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'; \
    ZSH_AUTOSUGGEST_STRATEGY=(history completion); \
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(up-line-or-beginning-search down-line-or-beginning-search); \
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1; \
    ZSH_AUTOSUGGEST_USE_ASYNC=1" \
    zsh-users/zsh-autosuggestions
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit ice depth=1; zinit light romkatv/powerlevel10k

source ~/.vim/config/fzf/completion.zsh
source ~/.vim/config/fzf/key-bindings.zsh

source ~/.vim/config/common.sh

setopt auto_cd
setopt complete_in_word
setopt always_to_end
setopt list_packed
setopt globdots
zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' menu yes select search
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

function chpwd() { emulate -L zsh; ls -ACF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.vim/config/.p10k.zsh ]] || source ~/.vim/config/.p10k.zsh
