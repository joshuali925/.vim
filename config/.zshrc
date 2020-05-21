ZSH_DISABLE_COMPFIX='true' # for autocomplete, skip the verification of insecure directories
autoload -U compinit && compinit -u  # for autocomplete
autoload -U colors && colors
unsetopt BG_NICE  # fix wsl bug

## History command configuration
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

setopt autocd

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%1~ "

source ~/.vim/config/common.sh
source ~/.vim/config/completion.zsh
source ~/.local/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.local/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

function chpwd() { emulate -L zsh; ls -ACF; }

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
