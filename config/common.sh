source ~/.vim/config/z.sh
export PYTHONSTARTUP=~/.vim/config/.pythonrc
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.vim/bin
export LS_COLORS=$(cat ~/.vim/config/.dircolors)

alias mkdir='mkdir -p'
alias ll='ls -AlhF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -CF --color=auto'
alias l='ls -CF --color=auto'
alias size='du -h --max-depth=1 | sort -hr'
alias v='vim'
alias vi='vim'
alias vf='vim $(fd | fzf --height 40%)'
alias vimm='vim ~/.vim/vimrc'
alias vims='vim -c "source ~/.cache/vim/session.vim"'
alias gacp='git add -A && git commit -m "update" && git push origin master'
alias venv='source venv/bin/activate'
alias service='sudo service'
alias apt='sudo apt'
alias which='type -a'  # zsh's which also works
alias cdf='cd $(fd --type="directory" | fzf --height 40%) && pwd'
alias zf='cd $(z --list | awk "{print \$2}" | fzf --height 40%) && pwd'

# alias f='a(){ find . -iname *$@*; }; a'
# alias cc='a(){ gcc $1.c -o $1 -g && ./$@; }; a'
function f { find . -iname \*$1\*; }
function cc { gcc $1.c -o $1 -g && ./$@; }

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
