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

set -gx PATH $HOME/.local/bin $HOME/.vim/bin $PATH
set PYTHONSTARTUP $HOME/.vim/others/.pythonrc


# fix color
for color_variable in (set -n | grep -e pure_color_)
    set --erase $color_variable
end
set --global pure_color_primary (set_color cyan)
source ~/.vim/fish/conf.d/pure.fish
