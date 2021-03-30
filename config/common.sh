source ~/.vim/config/z.sh
source ~/.vim/config/colors-icons.sh  # LS_COLORS and LF_ICONS

export PATH=$HOME/.local/bin:$PATH:$HOME/.vim/bin
export EDITOR='vim'
export BAT_PAGER='less -R --ignore-case'
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
export MANROFFOPT='-c'
export RIPGREP_CONFIG_PATH=~/.vim/config/.ripgreprc
export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_OPTS='--layout=reverse --height 40% --bind change:top'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files'
export FZF_ALT_C_COMMAND='ls -1A 2> /dev/null'
export FZF_ALT_C_OPTS='--bind "tab:down,btab:up"'
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --theme=OneHalfDark --line-range :50 {}'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias mv='mv -iv'
alias cp='cp -riv'
alias mkdir='mkdir -pv'
alias ll='ls -AlhF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -CF --color=auto'
alias l='ls -CF --color=auto'
alias size='du -h --max-depth=1 | sort -hr'
alias chmod\?='stat --printf "%a %n \n"'
alias v='vim'
alias vi='vim -u ~/.vim/config/mini.vim -i NONE'
alias vimm='vim ~/.vim/vimrc'
alias venv='source venv/bin/activate'
alias py='env PYTHONSTARTUP=$HOME/.vim/config/pythonrc.py python3'
alias service='sudo service'
alias apt='sudo apt'
alias lg='lazygit'
alias lf='lf -last-dir-path="$HOME/.cache/lf_dir"'
alias fl='lf -last-dir-path="$HOME/.cache/lf_dir" && cd "$(cat "$HOME/.cache/lf_dir")"'
alias 0='[ -f "$HOME/.cache/lf_dir" ] && cd "$(cat "$HOME/.cache/lf_dir")"'
alias rgf="rg --files | rg"
alias rgd="rg --files --null | xargs -0 dirname | sort -u | rg"
alias fpp='if [ -t 0 ] && [ $# -eq 0 ] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval $(fc -ln -1) | command fpp; else command fpp; fi'

alias ga='git add'
alias gau='git add -u'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
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
alias gpristine='git reset --hard && git clean -fdx'
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop || git checkout dev'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --stat'
alias gdst='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias ggl='git pull origin master'
alias glum='git pull upstream master'
alias ggp='git push origin master'
alias ggsup='git branch --set-upstream-to=origin/master'
alias gpsup='git push --set-upstream origin master'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gl='git pull'
alias glg='git log --stat --max-count=10'
alias glgg='git log --graph --max-count=10'
alias glgga='git log --graph --decorate --all'
alias glo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias gloo='git log --oneline --decorate --color'
alias gm='git merge'
alias gma='git merge --abort'
alias gmt='git mergetool --no-prompt'
alias gp='git push'
alias gpoat='git push origin --all && git push origin --tags'
alias gr='git remote'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase develop'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grbi='git rebase -i'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grl='git reflog --date=format:%T --pretty=format:"%C(yellow)%h%Creset %C(037)%gD:%Creset %C(white)%gs%Creset%C(auto)%d%Creset" --date=iso'
alias gra='git remote add'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grup='git remote update'
alias grv='git remote -v'
alias gs='git status'
alias gshow='git show --pretty=short --show-signature'
alias gss='git status -sb'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gts='git tag -s'
alias gtree='git ls-files | tree --fromfile'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "--wip--" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gvt='git verify-tag'
alias gwhere='git describe --tags `git rev-list --tags --max-count=1`'
alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'

d() {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}

cc() {
  gcc $1.c -o $1 -g && ./$@;
}

gdf() {
  git diff --color "$@" | diff-so-fancy | less --tabs=4 -RFX
}

gdd() {
  git diff "$@" | delta --line-numbers --navigate
}

gdg() {
  git diff "$@" | delta --line-numbers --navigate --side-by-side
}

printascii() {
  echo 'Dec Hex    Dec Hex    Dec Hex    Dec Hex  Dec Hex  Dec Hex   Dec Hex   Dec Hex'
  echo '  0 00 NUL  16 10 DLE  32 20 SPC  48 30 0  64 40 @  80 50 P   96 60 `  112 70 p'
  echo '  1 01 SOH  17 11 DC1  33 21 !    49 31 1  65 41 A  81 51 Q   97 61 a  113 71 q'
  echo '  2 02 STX  18 12 DC2  34 22 "    50 32 2  66 42 B  82 52 R   98 62 b  114 72 r'
  echo '  3 03 ETX  19 13 DC3  35 23 #    51 33 3  67 43 C  83 53 S   99 63 c  115 73 s'
  echo '  4 04 EOT  20 14 DC4  36 24 $    52 34 4  68 44 D  84 54 T  100 64 d  116 74 t'
  echo '  5 05 ENQ  21 15 NAK  37 25 %    53 35 5  69 45 E  85 55 U  101 65 e  117 75 u'
  echo '  6 06 ACK  22 16 SYN  38 26 &    54 36 6  70 46 F  86 56 V  102 66 f  118 76 v'
  echo "  7 07 BEL  23 17 ETB  39 27 '    55 37 7  71 47 G  87 57 W  103 67 g  119 77 w"
  echo '  8 08 BS   24 18 CAN  40 28 (    56 38 8  72 48 H  88 58 X  104 68 h  120 78 x'
  echo '  9 09 TAB  25 19 EM   41 29 )    57 39 9  73 49 I  89 59 Y  105 69 i  121 79 y'
  echo ' 10 0A LF   26 1A SUB  42 2A *    58 3A :  74 4A J  90 5A Z  106 6A j  122 7A z'
  echo ' 11 0B VT   27 1B ESC  43 2B +    59 3B ;  75 4B K  91 5B [  107 6B k  123 7B {'
  echo ' 12 0C FF   28 1C FS   44 2C ,    60 3C <  76 4C L  92 5C \  108 6C l  124 7C |'
  echo ' 13 0D CR   29 1D GS   45 2D -    61 3D =  77 4D M  93 5D ]  109 6D m  125 7D }'
  echo ' 14 0E SO   30 1E RS   46 2E .    62 3E >  78 4E N  94 5E ^  110 6E n  126 7E ~'
  echo ' 15 0F SI   31 1F US   47 2F /    63 3F ?  79 4F O  95 5F _  111 6F o  127 7F DEL'
}

printcolors() {
  printf 'Foreground 256 colors\n'
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
  printf '\n\nBackground 256 colors\n'
  for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
  printf '\e[0m\n\n'
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

x() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.xz)    tar xvJf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "Unable to extract '$1'" ;;
    esac
  else
    tar cvf $1.tar $1
  fi
}

path() {
  if [ -z "$1" ]; then
    echo -e ${PATH//:/\\n}
  else
    type -a "$@"
    declare -f "$@" || true
  fi
}

vf() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(rg --files | fzf --multi) && echo $FZFTEMP | xargs -d '\n' -o vim
  else
    FZFTEMP=$(rg --files | rg "$@" | fzf --multi) && echo $FZFTEMP | xargs -d '\n' -o vim
  fi
}

cdf() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(rg --files | fzf --bind 'tab:down,btab:up') && cd "$(dirname $FZFTEMP)"
  else
    FZFTEMP=$(rg --files | rg "$@" | fzf --bind 'tab:down,btab:up') && cd "$(dirname $FZFTEMP)"
  fi
}

vrg() {
  if [ "$#" -eq 0 ]; then echo 'Need a string to search for.'; return 1; fi
  if [[ \ $*\  == *\ --fixed-strings\ * ]] || [[ \ $*\  == *\ -F\ * ]]; then
    vim -q <(rg "$@" --vimgrep) -c "/\V$1"  # use \V if rg is called with -F/--fixed-strings to search for string literal
  else
    vim -q <(rg "$@" --vimgrep) -c "/$1"
  fi
}

fif() {
  if [ "$#" -eq 0 ]; then echo 'Need a string to search for.'; return 1; fi
  rg --files-with-matches --no-messages "$@" | fzf --multi --preview-window=up:60% --preview "rg --pretty --context 5 $(printf "%q " "$@"){+} --max-columns 0" --bind="enter:execute(vim {+} -c \"/$1\" < /dev/tty)"
}

unalias z 2> /dev/null
z() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(_z -l 2>&1 | fzf --tac --bind 'tab:down,btab:up') && cd "$(echo $FZFTEMP | sed 's/^[0-9,.]* *//')"
  else
    _z 2>&1 "$@"
  fi
}
zc() {
  local FZFTEMP=$(_z -c -l 2>&1 | fzf --tac --bind 'tab:down,btab:up' --query "$1") && cd "$(echo $FZFTEMP | sed 's/^[0-9,.]* *//')"
}

manf() {
  man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

nvm() {
  unset -f nvm node yarn
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm "$@"
}

node() {
  unset -f nvm node yarn
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  node "$@"
}

yarn() {
  unset -f nvm node yarn
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  yarn "$@"
}

docker-shell() {
  local CONTAINERS
  local SELECTED_ID
  CONTAINERS=`docker ps | grep -v IMAGE | awk '{printf "%s %-30s %s\n", $1, $2, $3}'`
  SELECTED_ID=`echo $CONTAINERS | fzf --height=40% --no-sort --tiebreak=begin,index`
  if [[ -n $SELECTED_ID ]]; then
    printf "\n → $SELECTED_ID\n"
    SELECTED_ID=`echo $SELECTED_ID | awk '{print $1}'`
    docker exec -it $SELECTED_ID /bin/bash
  fi
}
