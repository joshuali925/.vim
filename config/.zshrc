# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -U compinit && compinit -u  # for autocomplete
autoload -U colors && colors
[[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE  # fix wsl bug

source ~/.vim/config/fzf/completion.zsh
source ~/.vim/config/fzf/key-bindings.zsh
source ~/.vim/config/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen theme romkatv/powerlevel10k
antigen apply

source ~/.vim/config/common.sh

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
DIRSTACKSIZE=15
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # remove superfluous blanks before recording entry
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt autocd
setopt complete_in_word
setopt always_to_end
setopt list_packed
zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
autoload -U +X bashcompinit && bashcompinit

# PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} "

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

function chpwd() { emulate -L zsh; ls -ACF --color=auto; }

FAST_HIGHLIGHT[chroma-man]=
FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.vim/config/.p10k.zsh ]] || source ~/.vim/config/.p10k.zsh
