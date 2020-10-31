# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && command git clone https://github.com/zdharma/zinit --depth 1 ~/.zinit/bin
source ~/.zinit/bin/zinit.zsh

zinit depth=1 light-mode for romkatv/powerlevel10k

# zinit light zinit-zsh/z-a-bin-gem-node
# zinit light-mode as"program" from"gh-r" for \
#     mv"ripgrep* -> ripgrep" sbin"ripgrep/rg" BurntSushi/ripgrep \
#     mv"fd* -> fd" sbin"fd/fd" @sharkdp/fd \
#     mv"bat* -> bat" sbin"bat/bat" @sharkdp/bat \
#     sbin junegunn/fzf-bin \
#     sbin gokcehan/lf \
#     sbin jesseduffield/lazygit

zinit as"completion" for \
  https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd \
  https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg \
  https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
  https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose

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
  zsh-users/zsh-autosuggestions \
  supercrabtree/k

# vim <tab>: files in current directory or args completion
# vim <C-p>: all files in current and subdirectories, respects .gitignore
# vim \<tab>: all files in current and subdirectories
source ~/.vim/config/oh-my-zsh-key-bindings.zsh
source ~/.vim/config/fzf/key-bindings.zsh
source ~/.vim/config/fzf/completion.zsh
zinit light Aloxaf/fzf-tab  # load fzf-tab after fzf/completion.zsh

source ~/.vim/config/common.sh

autoload -Uz compinit && compinit -u
zinit cdreplay -q

WORDCHARS=${WORDCHARS/\/}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=40000

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
setopt share_history
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -CF --color=always -1 $realpath'

alias history='builtin fc -l 1'
alias k='k -h'

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

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[q' push-line-or-edit
bindkey '^q' push-line-or-edit
bindkey "^[[1;2A" up-line-or-local-history    # <S-Up>
bindkey "^[[1;2B" down-line-or-local-history  # <S-Down>

compdef _dirs d
function chpwd() { emulate -L zsh; ls -ACF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.vim/config/.p10k.zsh ]] || source ~/.vim/config/.p10k.zsh
