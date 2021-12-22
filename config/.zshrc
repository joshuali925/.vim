[ -n "$ZSHRC_INIT" ] && return || ZSHRC_INIT=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && command git clone https://github.com/zdharma-continuum/zinit --depth 1 ~/.zinit/bin && ZINIT_POST_INSTALL=1
source ~/.zinit/bin/zinit.zsh

if [ -n "$ZINIT_POST_INSTALL" ]; then
  zinit depth=1 light-mode for zdharma-continuum/z-a-bin-gem-node
  zinit light-mode as"program" from"gh-r" for \
    mv"ripgrep* -> ripgrep" sbin"ripgrep/rg" BurntSushi/ripgrep \
    mv"fd* -> fd" sbin"fd/fd" @sharkdp/fd \
    mv"bat* -> bat" sbin"bat/bat" @sharkdp/bat \
    mv"delta* -> delta" sbin"delta/delta" dandavison/delta \
    sbin junegunn/fzf \
    sbin gokcehan/lf \
    sbin jesseduffield/lazygit

  # zinit light-mode as"program" from"gh-r" for sbin jesseduffield/lazydocker
  # zinit light-mode as"program" from"gh-r" for sbin so-fancy/diff-so-fancy
  # zinit light-mode as"program" from"gh-r" for sbin schollz/croc
  # zinit light-mode as"program" from"gh-r" for sbin"bin/exa" ogham/exa
  # zinit light-mode as"program" from"gh-r" for mv"jq* -> jq" sbin stedolan/jq
  # zinit light-mode as"program" from"gh-r" for mv"uni* -> uni" sbin arp242/uni
  # zinit light-mode as"program" from"gh-r" for sbin pemistahl/grex
  # zinit light-mode as"program" from"gh-r" for mv"up* -> up" sbin akavel/up
  # zinit light-mode as"program" from"gh-r" for sbin XAMPPRocky/tokei
  # zinit light-mode as"program" from"gh-r" for mv"dust* -> dust" sbin"dust/dust" bootandy/dust
  # zinit light-mode as"program" from"gh-r" for sbin muesli/duf
  # zinit light-mode as"program" from"gh-r" for mv"gdu* -> gdu" sbin dundee/gdu
  # zinit light-mode as"program" from"gh-r" for mv"hyperfine* -> hyperfine" sbin"hyperfine/hyperfine" @sharkdp/hyperfine
  # zinit light-mode as"program" from"gh-r" for mv"shellcheck* -> shellcheck" sbin"shellcheck/shellcheck" koalaman/shellcheck
  # zinit light-mode as"program" from"gh-r" atclone"mv btm $ZPFX/bin" for ClementTsang/bottom

  zinit as"completion" for \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose \
    https://github.com/gradle/gradle-completion/blob/master/_gradle \
    https://github.com/gradle/gradle-completion/blob/master/gradle-completion.plugin.zsh \
    https://github.com/zsh-users/zsh-completions/blob/master/src/_yarn \
    https://github.com/zsh-users/zsh-completions/blob/master/src/_supervisorctl
fi

zinit depth=1 light-mode for romkatv/powerlevel10k
zinit depth=1 wait"0" lucid light-mode for \
  as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" tj/git-extras \
  atload"FAST_HIGHLIGHT[chroma-git]='chroma/-ogit.ch'\
  FAST_HIGHLIGHT[chroma-man]=" \
  atclone"zsh -c 'source $HOME/.zinit/plugins/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme clean'" \
  zdharma-continuum/fast-syntax-highlighting

zinit depth=1 light-mode for \
  atload"!_zsh_autosuggest_start; \
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'; \
  ZSH_AUTOSUGGEST_STRATEGY=(history completion); \
  ZSH_AUTOSUGGEST_HISTORY_IGNORE=\"?(#c150,)\"; \
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50; \
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(up-line-or-beginning-search down-line-or-beginning-search); \
  ZSH_AUTOSUGGEST_MANUAL_REBIND=1; \
  ZSH_AUTOSUGGEST_USE_ASYNC=1" \
  zsh-users/zsh-autosuggestions

zinit snippet OMZ::lib/key-bindings.zsh
source ~/.vim/config/fzf/key-bindings.zsh
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
zinit depth=1 light-mode for Aloxaf/fzf-tab  # load fzf-tab after fzf/completion.zsh

source ~/.vim/config/common.sh

autoload -Uz compinit && compinit -u
zinit cdreplay -q

WORDCHARS=${WORDCHARS/\/}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -AF --color=always -1 $realpath'
zstyle ':fzf-tab:*' switch-group '[' ']'

compdef _dirs d
compdef _tmux t
compdef _command_names path
compdef _git gdf=git-diff
compdef _git gdd=git-diff
compdef _git gdg=git-diff

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

# vim <tab>: files in current directory or args completion
# vim <C-p>: all files in current and subdirectories, respects .gitignore
# vim \<tab>: all files in current and subdirectories
tab-complete-or-cd() {
  if [[ -z "$BUFFER" ]]; then
    zle fzf-cd-widget
  else
    zle fzf-tab-complete
    # zle fzf-completion  # zsh original tab complete
  fi
}
zle -N tab-complete-or-cd

run-lf () {
  lf -last-dir-path="$HOME/.cache/lf_dir" < /dev/tty
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
bindkey '^i' tab-complete-or-cd
bindkey -s '^z' 'fg^m'

alias history='history -f 0'
alias get-completion='compdef _gnu_generic'
chpwd() { emulate -L zsh; [ $(command ls | wc -l) -lt 200 ] && ls -AF --color=auto; }

# To customize prompt, run `p10k configure` or edit ~/.vim/config/.p10k.zsh.
source ~/.vim/config/.p10k.zsh
