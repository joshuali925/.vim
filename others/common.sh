source ~/.vim/others/z.sh
export PYTHONSTARTUP=~/.vim/others/.pythonrc
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.vim/bin

alias mkdir='mkdir -p'
alias ll='ls -AlhF'
alias la='ls -AF'
alias l='ls -CF'
alias size='du -h --max-depth=1 | sort -hr'
alias vi='vim'
alias vimm='vim ~/.vimrc'
alias vims='vim -c "source ~/.cache/vim/session.vim"'
alias bpython='bpython -i'
alias gacp='git add -A && git commit -m "update" && git push origin master'
alias venv='source venv/bin/activate'
alias service='sudo service'
alias apt='sudo apt'
alias which='type -a'  # zsh's which also works

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
