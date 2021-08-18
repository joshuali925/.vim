source ~/.vim/config/z.sh
source ~/.vim/config/colors-icons.sh  # LS_COLORS and LF_ICONS

export PATH="$HOME/.local/bin:$HOME/.local/node-packages/node_modules/.bin:$PATH:$HOME/.vim/bin"
export EDITOR='nvim'
export BAT_PAGER='less -R --ignore-case'
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
export MANROFFOPT='-c'
export RIPGREP_CONFIG_PATH="$HOME/.vim/config/.ripgreprc"
export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_OPTS='--layout=reverse --height 40% --bind change:top'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files'
export FZF_ALT_C_COMMAND='command ls -1A 2> /dev/null'
export FZF_ALT_C_OPTS='--bind "tab:down,btab:up"'
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --theme=OneHalfDark --line-range :50 {}'

alias -- -='cd -'
alias 1='cd -1'
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
alias l='exa -alF --git --color=always --color-scale --icons --group-directories-first'
alias size='du -h --max-depth=1 | sort -hr'
alias chmod\?='stat --printf "%a %n \n"'
alias bell='echo -n -e "\a"'
alias v='$EDITOR'
alias vi='command vim -u ~/.vim/config/mini.vim -i NONE'
alias vim='$EDITOR'
alias vimm='nvim +PackerCompile +PackerInstall +PackerClean -c "cd ~/.vim" ~/.vim/config/nvim/init.lua'
alias venv='[ ! -d venv ] && python3 -m venv venv; source venv/bin/activate'
alias py='env PYTHONSTARTUP=$HOME/.vim/config/pythonrc.py python3'
alias btop='bpytop -b "cpu proc"'
alias croc='croc --curve p256'
alias lg='lazygit'
alias lzd='lazydocker'
alias lf='lf -last-dir-path="$HOME/.cache/lf_dir"'
alias 0='[ -f "$HOME/.cache/lf_dir" ] && cd "$(cat "$HOME/.cache/lf_dir")"'
alias rgf="rg --files | rg"
alias rgd="rg --files --null | xargs -0 dirname | sort -u | rg"
alias command-frequency="fc -l 1 | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl | head -n 30"
alias fpp='if [ -t 0 ] && [ $# -eq 0 ] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval $(fc -ln -1) | command fpp; else command fpp; fi'

alias ga='git add'
alias gau='git add -u'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a -vv'
alias gc='git commit -m'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcs='git commit -s -m'
alias gcs!='git commit -s --amend'
alias gcv='git commit -v'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gpristine='git reset --hard && git clean -fdx'
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop || git checkout dev'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --stat'
alias gdst='git diff --staged'
alias gdsst='git diff --stat --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gpf='git push fork $(git symbolic-ref --short HEAD)'
alias gpo='git push origin $(git symbolic-ref --short HEAD)'
alias gpu='git push upstream $(git symbolic-ref --short HEAD)'
alias gsup='FZFTEMP=$(git remote | fzf) && git branch --set-upstream-to=$FZFTEMP/$(git symbolic-ref --short HEAD) && unset FZFTEMP'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias gloo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --max-count 10'
alias gm='git merge'
alias gma='git merge --abort'
alias gmt='git mergetool --no-prompt'
alias gmlog='glo HEAD..'  # commits in target but not in HEAD (will be merged with git merge target)
gmdiff() {
  git diff HEAD..."$@"  # diff between target and the common ancestor of HEAD and target
}
alias gp='git push'
alias gr='git remote'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grbi='git rebase -i'
alias grl='git reflog --date=format:%T --pretty=format:"%C(yellow)%h%Creset %C(037)%gD:%Creset %C(white)%gs%Creset%C(auto)%d%Creset" --date=iso'
alias gra='git remote add'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grup='git remote update'
alias grv='git remote -v'
alias gs='git status'
alias gsall="find . -type d -name .git -execdir bash -c 'echo -e \"\\033[1;32m\"repo: \"\\033[1;34m\"\$([ \$(pwd) == '\$PWD' ] && echo \$(basename \$PWD) \"\\033[1;30m\"\(current directory\) || realpath --relative-to=\"'\$PWD'\" .) \"\\033[1;30m\"- \$(git symbolic-ref --short HEAD)\"\\033[0m\"; git status -s' \\;"
alias gss='git status -sb'
alias gshow='git show --pretty=short --show-signature'
alias gsu='git submodule update'
alias gts='git tag -s'
alias gtree='git ls-files | tree --fromfile'
alias gunignore='git update-index --no-assume-unchanged'
alias gunshallow='git remote set-branches origin "*" && git fetch -v && echo "\nRun \"git fetch --unshallow\" to fetch all history"'
alias gunwip='git log -n 1 | grep -q -c "--wip--" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gvt='git verify-tag'
alias gwhere='git describe --tags --abbrev=0; git branch -a --contains HEAD'
alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'

d() {
  if [ -n "$1" ]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
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

print-ascii() {
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

print-colors() {
  printf 'Foreground 8 colors\n'
  echo "$(tput setaf 0) black $(tput setaf 1) red $(tput setaf 2) green $(tput setaf 3) yellow $(tput setaf 4) blue $(tput setaf 5) magenta $(tput setaf 6) cyan $(tput setaf 7) white $(tput sgr 0)"
  printf '\nBackground 8 colors\n'
  echo "$(tput setab 0) black $(tput setab 1) red $(tput setaf 0)$(tput setab 2) green $(tput setab 3) yellow $(tput setaf 7)$(tput setab 4) blue $(tput setab 5) magenta $(tput setaf 0)$(tput setab 6) cyan $(tput setab 7) white $(tput sgr 0)"
  printf '\nANSI 16 colors\n'
  echo ' \e[0;30mblack="\\e[0;30m" \e[0;31mred="\\e[0;31m"     \e[0;32mgreen="\\e[0;32m" \e[0;33myellow="\\e[0;33m"'
  echo ' \e[0;34mblue="\\e[0;34m"  \e[0;35mmagenta="\\e[0;35m" \e[0;36mcyan="\\e[0;36m"  \e[0;37mwhite="\\e[0;37m"'
  echo -e ' \e[0mno_color="\\e[0m"       \u2191 original 8 colors      \u2193 lighter 8 colors'
  echo ' \e[1;30mblack="\\e[1;30m" \e[1;31mred="\\e[1;31m"     \e[1;32mgreen="\\e[1;32m" \e[1;33myellow="\\e[1;33m"'
  echo ' \e[1;34mblue="\\e[1;34m"  \e[1;35mmagenta="\\e[1;35m" \e[1;36mcyan="\\e[1;36m"  \e[1;37mwhite="\\e[1;37m"\e[0m'
  printf '\nForeground 256 colors\n'
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
      *.xz)        unxz $1        ;;
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
  local IFS=$'\n' FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=($(rg --files | fzf --multi))
  else
    FZFTEMP=($(rg --files | rg "$@" | fzf --multi))
  fi
  [ -n "$FZFTEMP" ] && $EDITOR "${FZFTEMP[@]}"
}

gvf() {
  local IFS=$'\n' FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=($(git ls-files $(git rev-parse --show-toplevel) | fzf --multi))
  else
    FZFTEMP=($(git ls-files $(git rev-parse --show-toplevel) | rg "$@" | fzf --multi))
  fi
  [ -n "$FZFTEMP" ] && $EDITOR "${FZFTEMP[@]}"
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
  if [ "$#" -eq 0 ]; then
    [[ ! $(fc -ln -1) =~ "^rg*" ]] && echo 'Need a string to search for.' || eval "v$(fc -ln -1)"
    return 0
  fi
  if [[ \ $*\  == *\ --fixed-strings\ * ]] || [[ \ $*\  == *\ -F\ * ]]; then
    $EDITOR -q <(rg "$@" --vimgrep) -c "/\V$1"  # use \V if rg is called with -F/--fixed-strings to search for string literal
  else
    $EDITOR -q <(rg "$@" --vimgrep) -c "/$1"
  fi
}

fif() {  # find in file
  if [ "$#" -eq 0 ]; then echo 'Need a string to search for.'; return 1; fi
  rg --files-with-matches --no-messages "$@" | fzf --multi --preview-window=up:60% --preview "rg --pretty --context 5 $(printf "%q " "$@"){+} --max-columns 0" --bind="enter:execute($EDITOR {+} -c \"/$1\" < /dev/tty)"
}

rf() {  # flygrep
  local RG_PREFIX="rg --column --line-number --no-heading --color=always "
  local INITIAL_QUERY="${*:-}"
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
  fzf --ansi \
      --disabled --query "$INITIAL_QUERY" \
      --bind "change:reload:sleep 0.2; $RG_PREFIX {q} || true" \
      --bind "enter:execute($EDITOR {1} +{2} -c \"let @/={q}\" -c \"set hlsearch\" < /dev/tty)" \
      --bind 'tab:down,btab:up' \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
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
  local FZFTEMP
  FZFTEMP=$(_z -c -l 2>&1 | fzf --tac --bind 'tab:down,btab:up' --query "$1") && cd "$(echo $FZFTEMP | sed 's/^[0-9,.]* *//')"
}

t() {  # create or switch tmux session
  local CHANGE CURRENT FZFTEMP
  [ -n "$TMUX" ] && CHANGE='switch-client' && CURRENT=$(tmux display-message -p '#{session_name}') || CHANGE='attach-session'
  if [ -z "$1" ]; then
    FZFTEMP=$(tmux list-sessions -F '#{session_name}' 2> /dev/null | sed "/^$CURRENT$/d" | fzf --bind 'tab:down,btab:up' --select-1 --exit-0) && tmux $CHANGE -t "$FZFTEMP" || echo 'No tmux sessions, pass a string to create one.'
  else
    tmux $CHANGE -t "$1" 2> /dev/null || (tmux new-session -d -s "$@" && tmux $CHANGE -t "$1")
  fi
}

manf() {
  if [ -z "$1" ]; then
    local FZFTEMP
    FZFTEMP=$(man -k . 2>/dev/null | awk 'BEGIN {FS=OFS="- "} /\([1|4]\)/ {gsub(/\([0-9]\)/, "", $1); if (!seen[$0]++) { print }}' | fzf --bind 'tab:down,btab:up' --prompt='man> ' --preview $'echo {} | xargs -r man') && nvim +"Man $(echo "$FZFTEMP" | awk -F' |,' '{print $1}')" +'bdelete #' +'nnoremap <buffer> d <C-d>' +'nnoremap <buffer> u <C-u>'
  else
    nvim +"Man $@" +'bdelete #' +'nnoremap <buffer> <nowait> d <C-d>' +'nnoremap <buffer> u <C-u>'
  fi
}

envf() {
  local FZFTEMP
  FZFTEMP=$(printenv | cut -d= -f1 | fzf --bind 'tab:down,btab:up' --query "$1" --preview 'printenv {}') && echo "$FZFTEMP=$(printenv "$FZFTEMP")"
}

react() {
  if [ "$#" -lt 2 ]; then echo 'Usage: react <dir_to_watch> <command>, use {} as placeholder of modified files.'; return 1; fi
  local CHANGED
  echo "Watching \"$1\", passing modified files to \"${@:2}\" command every 2 seconds."
  while true; do
    CHANGED=($(fd --base-directory $1 --absolute-path --type=f --changed-within 2s))
    if [ $CHANGED ]; then
      eval "${${@:2}//\{\}/${CHANGED[@]}}"
    fi
    sleep 2
  done
}

try-until-success() {
  local i=1
  while true; do
    echo "Try $i, $(date)."
    $* && break
    ((i+=1))
    echo
  done
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
