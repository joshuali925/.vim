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
#   sbin jesseduffield/lazygit \
#   sbin jesseduffield/lazydocker \
#   mv"ripgrep* -> ripgrep" sbin"ripgrep/rg" BurntSushi/ripgrep \
#   mv"fd* -> fd" sbin"fd/fd" @sharkdp/fd \
#   mv"bat* -> bat" sbin"bat/bat" @sharkdp/bat \
#   mv"delta* -> delta" sbin"delta/delta" dandavison/delta \
#   sbin junegunn/fzf-bin \
#   sbin gokcehan/lf

zinit as"completion" for \
  https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg \
  https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd \
  https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
  https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose \
  https://github.com/gradle/gradle-completion/blob/master/_gradle \
  https://github.com/gradle/gradle-completion/blob/master/gradle-completion.plugin.zsh \
  https://github.com/zsh-users/zsh-completions/blob/master/src/_yarn

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
zplugin ice ver'fe9fa652390c78859450838825a8b5c40e9921ef'  # use this commit if master doesn't work
zinit light Aloxaf/fzf-tab  # load fzf-tab after fzf/completion.zsh

source ~/.vim/config/common.sh

autoload -Uz compinit && compinit -u
zinit cdreplay -q

WORDCHARS=${WORDCHARS/\/}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

[[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE  # fix wsl bug
unsetopt flow_control  # man zshoptions; man zshbuiltins
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
setopt hist_verify

zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -CF --color=always -1 $realpath'
zstyle ':fzf-tab:*' switch-group '[' ']'

alias history='history -f 0'
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
tab-complete-or-cd() {
  if [[ -z "$BUFFER" ]]; then
    zle fzf-cd-widget
  else
    zle fzf-tab-complete
    # zle fzf-completion  " old tab complete
  fi
}
zle -N tab-complete-or-cd

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[q' push-line-or-edit
bindkey '^q' push-line-or-edit
bindkey "^[[1;2A" up-line-or-local-history    # <S-Up>
bindkey "^[[1;2B" down-line-or-local-history  # <S-Down>
bindkey '^i' tab-complete-or-cd
bindkey -s '^z' 'fg^m'

compdef _dirs d
compdef _command_names path
compdef _git gdf=git-diff
compdef _git gdd=git-diff
compdef _git gdg=git-diff
function chpwd() { emulate -L zsh; ls -ACF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.vim/config/.p10k.zsh.
[[ ! -f ~/.vim/config/.p10k.zsh ]] || source ~/.vim/config/.p10k.zsh
