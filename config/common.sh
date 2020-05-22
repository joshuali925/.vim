source ~/.vim/config/z.sh

export PYTHONSTARTUP=~/.vim/config/.pythonrc
export PATH=$HOME/.local/bin:$PATH:$HOME/.vim/bin
export LS_COLORS=$(cat ~/.vim/config/.dircolors)

export FZF_DEFAULT_OPTS='--layout=reverse --height 40%'
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'
export FZF_CTRL_T_COMMAND='rg --files --hidden -g "!.git"'
export FZF_ALT_C_COMMAND="rg --files --hidden -g '!.git' --null | xargs -0 dirname | awk '!h[\$0]++'"

alias -- -='cd -'
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'
alias ll='ls -AlhF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -CF --color=auto'
alias l='ls -CF --color=auto'
alias size='du -h --max-depth=1 | sort -hr'
alias v='vim'
alias vi='vim'
alias vimm='vim ~/.vim/vimrc'
alias gacp='git add -A && git commit -m "update" && git push origin master'
alias venv='source venv/bin/activate'
alias service='sudo service'
alias apt='sudo apt'
alias which='type -a'  # zsh's which also works
alias vf='vim $(fd --hidden --exclude ".git" | fzf)'
alias zf='cd $(z --list | awk "{print \$2}" | fzf) && pwd'
alias rgf='rg --files --hidden -g "!.git" | rg'
alias rgd='rg --files --hidden -g "!.git" --null | xargs -0 dirname | sort -u | rg'

alias g='git'
alias ga='git add'
alias gau='git add -u'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpnp='git pull origin master && git push origin master'
alias ggpull='git pull origin master'

# alias f='a(){ find . -iname *$@*; }; a'
# alias cc='a(){ gcc $1.c -o $1 -g && ./$@; }; a'
function f {
    find . -iname \*$1\*;
}
function cc {
    gcc $1.c -o $1 -g && ./$@;
}
function gdf {
    git diff "$@" | diff-so-fancy | less --tabs=4 -RFX
}

function printcolor {
    awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
    }'
}

function fl () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

nvm() {
    unset -f nvm
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    nvm "$@"
}

node() {
    unset -f node
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    node "$@"
}

yarn() {
    unset -f yarn
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    yarn "$@"
}
