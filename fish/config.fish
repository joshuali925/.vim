# To install extensions, run
# fisher add jethrokuan/z rafaelrinaldi/pure

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
alias venv='source venv/bin/activate.fish'
alias service='sudo service'
alias apt='sudo apt'
alias which='type -a'

function echo_dir --on-variable PWD; ls -CF; end;
