source ~/.vim/config/z.sh
source ~/.vim/config/colors-icons.sh  # LS_COLORS and LF_ICONS

export PATH="$HOME/.local/bin:$HOME/.local/lib/node-packages/node_modules/.bin:$PATH:$HOME/.vim/bin"
export EDITOR='nvim'
export LESS='-RiM'  # default -RiM: --RAW-CONTROL-CHARS --ignore-case --LONG-PROMPT, -XF: exit if one screen
export BAT_PAGER="less $LESS"
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
export MANROFFOPT='-c'
export RIPGREP_CONFIG_PATH="$HOME/.vim/config/.ripgreprc"
export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_OPTS='--layout=reverse --height=40% --bind=change:top'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files'
export FZF_ALT_C_COMMAND='command ls -1Ap 2> /dev/null'
export FZF_ALT_C_OPTS='--bind="tab:down,btab:up"'
export FZF_PREVIEW_COMMAND='bat --color=always --style=numbers --theme=OneHalfDark --line-range :50 {}'

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
alias mv='mv -iv'
alias cp='cp -riv'
alias mkdir='mkdir -pv'
alias ll='ls -AlhF --color=auto'
alias ls='ls -F --color=auto'
alias l='exa -alF --git --color=always --color-scale --icons --group-directories-first'
alias size='du -h --max-depth=1 | sort -hr'
alias chmod\?='stat --printf "%a %n \n"'
alias bell='echo -n -e "\a"'
alias title='printf "$([ -n "$TMUX" ] && printf "\033Ptmux;\033")\e]0;%s\e\\$([ -n "$TMUX" ] && printf "\033\\")"'
alias v='$EDITOR'
alias vi='command vim -u ~/.vim/config/mini.vim -i NONE'
alias vim='$EDITOR'
alias vimm='nvim +PackerCompile +PackerInstall +PackerClean -c "cd ~/.vim" ~/.vim/config/nvim/init.lua'
alias venv='[ ! -d venv ] && python3 -m venv venv; source venv/bin/activate'
alias py='env PYTHONSTARTUP=$HOME/.vim/config/pythonrc.py python3'
alias lg='lazygit'
alias lzd='lazydocker'
alias lf='lf -last-dir-path="$HOME/.cache/lf_dir"'
alias 0='[ -f "$HOME/.cache/lf_dir" ] && cd "$(cat "$HOME/.cache/lf_dir")"'
alias q='q --output-header --pipe-delimited-output --beautify --delimiter=, --skip-header'
alias q-="up -c \"\$(alias q | sed \"s/[^']*'\\(.*\\)'/\\1/\") 'select * from -'\""
alias rga='rg --text --no-ignore --search-zip'
alias rgf='rg --files | rg'
alias rgd='rg --files --null | xargs -0 dirname | sort -u | rg'
alias xcp="rsync -aviHKhSPz --no-owner --no-group --one-file-system --delete --filter=':- .gitignore'"
alias fpp='if [ -t 0 ] && [ $# -eq 0 ] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval $(fc -ln -1) | command fpp; else command fpp; fi'
alias http.server='filebrowser --database $HOME/.cache/filebrowser.db --disable-exec --noauth --address 0.0.0.0 --port 8000'
alias command-frequency="fc -l 1 | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | column -c3 -s \" \" -t | sort -nr | head -n 30 | nl"
alias command-frequency-with-args="fc -l 1 | awk '{\$1=\"\"; CMD[\$0]++;count++;}END { for (a in CMD)print CMD[a] \"\\t\" CMD[a]/count*100 \"%\\t\" a;}' | sort -nr | head -n 30 | nl | column -c3 -s \$'\\t' -t"

alias ga='git add'
alias gau='git add -u'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a -vv --sort=-committerdate'
alias gbl='git for-each-ref --sort=-committerdate refs/heads --format="%(HEAD)%(color:yellow)%(refname:short)|%(color:green)%(committerdate:relative)|%(color:red)%(objectname:short)%(color:reset) - %(subject) %(color:bold blue)<%(authorname)>%(color:reset)" --color=always | column -ts"|"'
alias gc='git commit -m'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcs='git commit -s -m'
alias gcs!='git commit -s --amend'
alias gcv='git commit -v'
alias gcf='git config --list'
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop || git checkout dev'
alias gco='git checkout'
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
alias ggl='git pull --autostash origin $(gref)'
alias gpf='git push fork $(gref)'
alias gsup='git remote | fzf --bind="tab:down,btab:up" | xargs -I {} git branch --set-upstream-to={}/$(git symbolic-ref --short HEAD)'
alias gl='git pull --autostash'
alias glr='git pull --rebase'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias gloo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --max-count 10'
alias gm='git merge'
alias gma='git merge --abort'
alias gmt='git mergetool --no-prompt'
alias gmerge-preview-log='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit HEAD..'  # commits in target but not in HEAD (will be merged with git merge target)
gmerge-preview-diff() { git diff HEAD..."$*"; }  # diff between target and the common ancestor of HEAD and target
alias gr='git remote'
alias gref='git symbolic-ref --short HEAD'
alias grref='git rev-parse --abbrev-ref --symbolic-full-name @{upstream}'  # remote ref
alias grl='git reflog --date=format:%T --pretty=format:"%C(yellow)%h%Creset %C(037)%gD:%Creset %C(white)%gs%Creset%C(auto)%d%Creset" --date=iso'
alias gra='git remote add'
alias gra-fork="git remote add fork \"\$(git remote get-url origin | sed 's,\(https://\|git@\)\([^:/]\+\)[:/][^/]\+/\([^/]\+\)/\?$,git@\2:joshuali925/\3,')\"; git remote -v"
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias greset-to-remote='git reset --hard @{upstream}'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grv='git remote -v'
alias gs='git status'
alias gsall="find . -type d -name .git -execdir bash -c 'echo -e \"\\033[1;32m\"repo: \"\\033[1;34m\"\$([ \$(pwd) == '\$PWD' ] && echo \$(basename \$PWD) \"\\033[1;30m\"\(current directory\) || realpath --relative-to=\"'\$PWD'\" .) \"\\033[1;30m\"- \"\\033[1;33m\"\$(git symbolic-ref --short HEAD)\"\\033[1;30m\"\$(git log --pretty=format:\" (%cr)\" --max-count 1)\"\\033[0m\"; git status -s' \\;"
alias gss='git status -sb'
alias gstash='git stash'
alias gshow='git show --pretty=short --show-signature'
alias gts='git tag -s'
alias gcount='git shortlog -sn'
alias gtree='git ls-files | tree --fromfile'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gunignore='git update-index --no-assume-unchanged'
alias gpristine='git stash push --include-untracked --message "gpristine temporary stash"; git reset --hard && git clean -fdx'
alias gunshallow='git remote set-branches origin "*" && git fetch -v && echo "\nRun \"git fetch --unshallow\" to fetch all history"'
alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'
alias gunwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
alias gwhatchanged='git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --name-status $(git rev-parse --abbrev-ref --symbolic-full-name @{upstream})..HEAD  # what will be pushed'
alias gwhatsnew='git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --name-status ORIG_HEAD...HEAD  # what was pulled'
alias gwhere='git describe --tags --abbrev=0; git branch -a --contains HEAD'
alias gsize='git rev-list --objects --all | git cat-file --batch-check="%(objecttype) %(objectname) %(objectsize) %(rest)" | sed -n "s/^blob //p" | sort --numeric-sort --key=2 | cut -c 1-12,41- | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest'  # use "git obliterate <filepath>; git gc --prune=now --aggressive" to remove
alias gforest='git-foresta --style=10 | less -XF'
alias gforesta='git-foresta --style=10 --all | less -XF'
alias gls-files-all="git log --pretty=format: --name-only --all | awk NF | sort -u | fzf --height=50% --min-height=20 --ansi --multi --preview='git log --color=always --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --abbrev-commit --all -- {}' | xargs -I{} bash -c 'echo {}; git log --color=always --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --abbrev-commit --all --max-count 10 -- {}'"
alias gpatch='vi +"syntax enable" +startinsert patch.diff && git apply patch.diff && rm patch.diff'

d() { [ "$#" -eq 0 ] && dirs -v | head -10 || dirs "$@"; }
gdf() { git diff --color "$@" | diff-so-fancy | less --tabs=4 -XF; }
gdd() { git diff "$@" | delta --line-numbers --navigate; }
gdg() { git diff "$@" | delta --line-numbers --navigate --side-by-side; }
grg() { git log --patch --color=always --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --regexp-ignore-case -G "$@" | less -XF --pattern="$*"; }

glof() {
  git log --graph --color=always --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit "$@" |
    fzf --height=50% --min-height=20 --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` --multi \
    --header='Press ` to toggle sort, <C-y> to copy commit, <C-p> , . to control preview' \
    --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show | delta --dark --paging=never' \
    --bind='ctrl-p:toggle-preview,,:preview-down,.:preview-up' \
    --bind='ctrl-y:execute(echo {+} | grep -o "[a-f0-9]\{7,\}" | tr "\n" " " | y)+abort' \
    --bind='enter:execute(echo {} | grep -o "[a-f0-9]\{7,\}" | xargs git show | delta --line-numbers --navigate)'
}

gcb() {
  if [ -n "$1" ]; then
    git checkout -b "$@" || git checkout "$@"
  else
    local FZFTEMP=$(git branch --color=always --sort=-committerdate --all |
      awk '/remotes\//{a[++c]=$0;next}1;END{for(i=1;i<=c;++i) print a[i]}' |
      fzf --height=50% --min-height=20 --ansi --no-sort --reverse --tiebreak=index --preview-window=60% --toggle-sort=\` \
      --header='Press ` to toggle sort' \
      --preview='git log -n 50 --color=always --graph --pretty=format:"%Cred%h%Creset - %Cgreen(%cr)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset" --abbrev-commit $(sed "s/.* //" <<< {})' | sed "s/.* //")
    [ -n "$FZFTEMP" ] && git checkout "${FZFTEMP#remotes/[^\/]*/}"
  fi
}

pscpu() {
  local ps_out pids pid pstree_flags pstree_out
  if [ "$(uname -s)" = Darwin ]; then
    ps_out=$(ps -rwwAo user,pid,ppid,pcpu,pmem,time,command)
    pstree_flags='-wp'
  else
    ps_out=$(ps auxww --sort=-pcpu)
    pstree_flags='-Glps'
  fi
  [ -z "$1" ] && echo "$ps_out" | head -n 11
  if [ ! -x "$(command -v pstree)" ]; then
    echo 'pstree not found (e.g. yum install -y psmisc).'
  else
    if [ -n "$1" ]; then
      pids=($(grep -i "$@" <<< "$ps_out" | awk '{print $2}'))
    else
      pids=($(sed -n '2,4p' <<< "$ps_out" | awk '{print $2}'))
    fi
    for pid in "${pids[@]}"; do
      pstree_out=$(pstree "$pstree_flags" "$pid")
      [[ $pstree_out =~ "$pid" ]] && head -n 8 <<< "$pstree_out" | grep --color -E "^|$pid"
    done
  fi
}

psmem() {
  local ps_out
  if [ "$(uname -s)" = Darwin ]; then
    ps_out=$(ps -mwwAo pid,rss,command)
  else
    ps_out=$(ps axwwo pid,rss,args --sort -size)
  fi
  echo "$ps_out" | head -n 16 | awk '{ hr=$2/1024 ; printf("%7s %9.2f Mb\t",$1,hr) } { for ( x=3 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'
}

sudorun() {
  if [ "$#" -eq 0 ]; then echo 'Need a command to run.'; return 1; fi
  local CMD=$1
  shift
  if [ ! -x "$(command -v "$CMD")" ] && type "$CMD" | grep -q "$CMD is a \(shell \)\?function"; then
    echo -e "Running as bash function..\n" >&2
    sudo bash -c "$(declare -f "$CMD"); $CMD"
    return 0
  fi
  case $CMD in
    v|vi|vim) sudo "$(/usr/bin/which vim)" -u "$HOME/.vim/config/mini.vim" +'syntax enable' "$@" ;;
    lf) EDITOR="vim -u $HOME/.vim/config/mini.vim" XDG_CONFIG_HOME="$HOME/.config" sudo -E "$(/usr/bin/which lf)" -last-dir-path="$HOME/.cache/lf_dir" -command 'set previewer' "$@" ;;
    *) XDG_CONFIG_HOME="$HOME/.config" EDITOR="vim -u $HOME/.vim/config/mini.vim" sudo -E "$(/usr/bin/which "$CMD")" "$@" ;;
  esac
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

print-colors() {  # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
  printf 'Foreground 8 colors\n'
  echo "$(tput setaf 0) black $(tput setaf 1) red $(tput setaf 2) green $(tput setaf 3) yellow $(tput setaf 4) blue $(tput setaf 5) magenta $(tput setaf 6) cyan $(tput setaf 7) white $(tput sgr 0)"
  printf '\nBackground 8 colors\n'
  echo "$(tput setab 0) black $(tput setab 1) red $(tput setaf 0)$(tput setab 2) green $(tput setab 3) yellow $(tput setaf 7)$(tput setab 4) blue $(tput setab 5) magenta $(tput setaf 0)$(tput setab 6) cyan $(tput setab 7) white $(tput sgr 0)"
  printf '\nANSI 16 colors\n'
  echo -e ' \e[0;30mblack="\\e[0;30m" \e[0;31mred="\\e[0;31m"     \e[0;32mgreen="\\e[0;32m" \e[0;33myellow="\\e[0;33m"'
  echo -e ' \e[0;34mblue="\\e[0;34m"  \e[0;35mmagenta="\\e[0;35m" \e[0;36mcyan="\\e[0;36m"  \e[0;37mwhite="\\e[0;37m"'
  echo -e ' \e[0mno_color="\\e[0m"       \u2191 original 8 colors      \u2193 lighter 8 colors'
  echo -e ' \e[1;30mblack="\\e[1;30m" \e[1;31mred="\\e[1;31m"     \e[1;32mgreen="\\e[1;32m" \e[1;33myellow="\\e[1;33m"'
  echo -e ' \e[1;34mblue="\\e[1;34m"  \e[1;35mmagenta="\\e[1;35m" \e[1;36mcyan="\\e[1;36m"  \e[1;37mwhite="\\e[1;37m"\e[0m'
  printf '\nForeground 256 colors\n'
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' "$i" "$i"; (((i+3) % 18)) || printf '\e[0m\n'; done
  printf '\n\nBackground 256 colors\n'
  for i in {0..255}; do printf '\e[48;5;%dm%3d ' "$i" "$i"; (((i+3) % 18)) || printf '\e[0m\n'; done
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
  if [ -f "$1" ]; then
    case $1 in
      *.tar)                       tar xvf "$1"     ;;
      *.tar.gz | *.tgz)            tar xvzf "$1"    ;;
      *.tar.xz | *.xz)             tar xvJf "$1"    ;;
      *.tar.bz2 | *.tbz | *.tbz2)  tar xvjf "$1"    ;;
      *.bz2)                       bunzip2 "$1"     ;;
      *.gz)                        gunzip "$1"      ;;
      *.zip)                       unzip "$1"       ;;
      *.rar)                       unrar x "$1"     ;;
      *.Z)                         uncompress "$1"  ;;
      *.7z)                        7z x "$1"        ;;
      *)                           echo "Unable to extract '$1'" ;;
    esac
  else
    tar czvf "$1.tar.gz" "$1"
  fi
}

X() {  # extract to a directory / archive without top directory
  if [ -f "$1" ]; then
    local dir="${1%.*}"
    local filename="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)_$1"
    command mkdir -pv "$dir"
    command mv -i "$1" "$dir/$filename"
    (cd "$dir" > /dev/null && x "$filename")
    command mv -n "$dir/$filename" "$1"
  else
    tar czvf "$1.tar.gz" -C "$1" .
    return 0
  fi
}

path() {
  if [ -z "$1" ]; then
    echo -e "${PATH//:/\\n}"
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
    FZFTEMP=$(rg --files | fzf --bind='tab:down,btab:up') && cd "$(dirname "$FZFTEMP")"
  else
    FZFTEMP=$(rg --files | rg "$@" | fzf --bind='tab:down,btab:up') && cd "$(dirname "$FZFTEMP")"
  fi
}

vrg() {
  if [ "$#" -eq 0 ]; then
    [[ ! $(fc -ln -1) =~ ^rg* ]] && echo 'Need a string to search for.' || eval "v$(fc -ln -1)"
    return 0
  fi
  if [[ \ $*\  = *\ --fixed-strings\ * ]] || [[ \ $*\  = *\ -F\ * ]]; then
    $EDITOR -q <(rg "$@" --vimgrep) -c "/\V$1"  # use \V if rg is called with -F/--fixed-strings to search for string literal
  else
    $EDITOR -q <(rg "$@" --vimgrep) -c "/$1"
  fi
}

# https://github.com/junegunn/fzf/blob/3c804bcfec7c1f3cb69398f6d74f77a25286dbcb/ADVANCED.md#ripgrep-integration
fif() {  # find in file
  if [ "$#" -eq 0 ]; then echo 'Need a string to search for.'; return 1; fi
  rg --files-with-matches --no-messages "$@" | fzf --multi --preview-window=up:60% --preview="rg --pretty --context 5 $(printf "%q " "$@"){+} --max-columns 0" --bind="enter:execute($EDITOR {+} -c \"/$1\" < /dev/tty)"
}
rf() {  # livegrep: rf [pattern] [flags], pattern must be before flags, <C-s> to switch to fzf filter
  [ "$#" -gt 0 ] && [[ "$1" != -* ]] && local INIT_QUERY="$1" && shift 1
  local RG_PREFIX="rg --column --line-number --no-heading --color=always$([ "$#" -gt 0 ] && printf " %q" "$@")"
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "${INIT_QUERY:-}")" \
  fzf --ansi --layout=default --height=100% --disabled --query="${INIT_QUERY:-}" \
      --bind="ctrl-s:unbind(change,ctrl-s)+change-prompt(2. fzf> )+enable-search+clear-query" \
      --bind="change:reload:sleep 0.2; $RG_PREFIX {q}" \
      --bind="enter:execute($EDITOR {1} +{2} -c \"let @/={q}\" -c \"set hlsearch\" < /dev/tty)" \
      --bind='tab:down,btab:up' \
      --prompt='1. ripgrep> ' --delimiter=: \
      --preview='bat --theme=Dracula --color=always {1} --highlight-line {2}' \
      --preview-window='up,40%,border-bottom,+{2}+3/3,~3'
}

unalias z 2> /dev/null
z() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(_z -l 2>&1 | fzf --tac --bind='tab:down,btab:up') && cd "$(echo "$FZFTEMP" | sed 's/^[0-9,.]* *//')"
  else
    _z 2>&1 "$@"
  fi
}
zc() {
  local FZFTEMP
  FZFTEMP=$(_z -c -l 2>&1 | fzf --tac --bind='tab:down,btab:up' --query="$1") && cd "$(echo "$FZFTEMP" | sed 's/^[0-9,.]* *//')"
}

t() {  # create, restore, or switch tmux session
  local CHANGE CURRENT FZFTEMP SESSIONS
  [ -n "$TMUX" ] && CHANGE='switch-client' && CURRENT=$(tmux display-message -p '#{session_name}') || CHANGE='attach-session'
  if [ -z "$1" ]; then
    FZFTEMP=$(tmux list-sessions -F '#{session_name}' 2> /dev/null | sed "/^$CURRENT$/d" | fzf --prompt='attach> ' --bind='tab:down,btab:up' --select-1 --exit-0) && tmux $CHANGE -t "$FZFTEMP"
    if [ "$?" -ne 0 ]; then
      SESSIONS=$(ls ~/.tmux/resurrect/tmux_resurrect_*.txt 2> /dev/null)
      [ -n "$SESSIONS" ] && FZFTEMP=$(echo "$SESSIONS" | fzf --prompt='restore> ' --bind='ctrl-d:execute(mv {} {}.bak)' --bind='tab:down,btab:up' --tac --preview='cat {}') && {
        ln -sf "$FZFTEMP" ~/.tmux/resurrect/last
        tmux new-session -d " tmux run-shell $HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"
        tmux attach-session
      } || tmux
    fi
  else
    tmux $CHANGE -t "$1" 2> /dev/null || (tmux new-session -d -s "$@" && tmux $CHANGE -t "$1")
  fi
}

manf() {
  if [ -z "$1" ]; then
    local FZFTEMP
    FZFTEMP=$(man -k . 2> /dev/null | awk 'BEGIN {FS=OFS="- "} /\([1|4]\)/ {gsub(/\([0-9]\)/, "", $1); if (!seen[$0]++) { print }}' | fzf --bind='tab:down,btab:up' --prompt='man> ' --preview=$'echo {} | xargs -r man') && nvim +"Man $(echo "$FZFTEMP" | awk -F' |,' '{print $1}')" +'bdelete #' +'nnoremap <buffer> <nowait> d <C-d>' +'nnoremap <buffer> u <C-u>'
  else
    nvim +"Man $*" +'bdelete #' +'nnoremap <buffer> <nowait> d <C-d>' +'nnoremap <buffer> u <C-u>'
  fi
}

envf() {
  local FZFTEMP
  FZFTEMP=$(printenv | cut -d= -f1 | fzf --bind='tab:down,btab:up' --query="$1" --preview='printenv {}') && echo "$FZFTEMP=$(printenv "$FZFTEMP")"
}

react() {
  if [ "$#" -lt 2 ]; then echo "Usage: $0 <dir_to_watch> <command>, use {} as placeholder of modified files."; return 1; fi
  local CHANGED
  echo "Watching \"$1\", passing modified files to \"${*:2}\" command every 2 seconds."
  while true; do
    CHANGED=($(fd --base-directory "$1" --absolute-path --type=f --changed-within 2s))
    if [ ${#CHANGED[@]} -gt 0 ]; then
      eval "${${@:2}//\{\}/${CHANGED[@]}}"
    fi
    sleep 2
  done
}

untildone() {
  if [ "$#" -eq 0 ]; then
    echo -e "Usage: $0 <command>\n\t$0 wget -c <url>  # wget until complete\n\t$0 'git pull; sleep 3599; false'  # git pull every hour"
    return 1
  fi
  local i=1
  while true; do
    echo "Try $i, $(date)." >&2
    eval "$@" && break
    ((i+=1))
    sleep 1
    echo >&2
  done
}

croc() {
  local line phrase
  if [ "$#" -eq 0 ]; then
    command croc
  elif grep -q '^[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<<"$1"; then
    command croc --curve p256 --yes "$@"
  elif [ -e "$1" ] || [ "$1" = send ]; then
    [ "$1" = send ] && shift 1
    timeout 60 croc send "$@" 2>&1 | {
      while read line; do
        echo "$line"
        [ -z "$phrase" ] && phrase=$(grep -o '[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<<"$line") && echo -n "command croc --curve p256 --yes $phrase" | y
      done
    }
  else
    command croc "$@"
  fi
}

_load_nvm() {
  unset -f _load_nvm nvm npx node yarn
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}
nvm() { _load_nvm && nvm "$@"; }
npx() { _load_nvm && npx "$@"; }
node() { _load_nvm && node "$@"; }
yarn() { _load_nvm && yarn "$@"; }

docker-shell() {
  local CONTAINERS SELECTED_ID
  CONTAINERS=$(docker ps | grep -v IMAGE | awk '{printf "%s %-30s %s\n", $1, $2, $3}')
  SELECTED_ID=$(echo "$CONTAINERS" | fzf --height=40% --no-sort --tiebreak=begin,index)
  if [[ -n $SELECTED_ID ]]; then
    printf "\n → %s\n" "$SELECTED_ID"
    SELECTED_ID=$(echo "$SELECTED_ID" | awk '{print $1}')
    docker exec -it "$SELECTED_ID" /bin/sh -c 'eval $(grep ^$(id -un): /etc/passwd | cut -d : -f 7-)'
  fi
}

ec2() {
  local INSTANCES IDS CURR_STATE
  case $1 in
    start) CURR_STATE='stopped' ;;
    stop) CURR_STATE='running' ;;
    refresh)
      aws ec2 describe-instances --filter "Name=tag-key,Values=Name" "Name=tag-value,Values=*" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*][NetworkInterfaces[0].Association.PublicDnsName,Tags[?Key=='Name'].Value[] | [0]]" --output text
      return 0 ;;
    *) echo "Usage: $0 {start|stop|refresh} [instance-tag]"; return 1 ;;
  esac
  INSTANCES=$(aws ec2 describe-instances --filter "Name=tag-key,Values=Name" "Name=tag-value,Values=*" "Name=instance-state-name,Values=$CURR_STATE" --query "Reservations[*].Instances[*][Tags[?Key=='Name'].Value[] | [0],InstanceId]" --output text)
  if [ -n "$2" ]; then
    IDS=$(echo "$INSTANCES" | grep -w "$2" | awk '{print $2}')
  else
    IDS=$(echo "$INSTANCES" | fzf --multi | awk '{print $2}')
  fi
  [ -z "$IDS" ] && return 1
  if [ "$CURR_STATE" = stopped ]; then
    aws ec2 start-instances --instance-ids $(echo $IDS)
  else
    aws ec2 stop-instances --instance-ids $(echo $IDS)
  fi
}

# ====================== MacOS ==========================
alias idea='open -na "IntelliJ IDEA.app" --args'
alias ideace='open -na "IntelliJ IDEA CE.app" --args'
browser-history() {
  [ "$(uname -s)" != Darwin ] && echo "Only supports MacOS, exiting.." && return 1
  local COLS SEP FZFTEMP FZFPROMPT
  COLS=$(( COLUMNS / 3 ))
  SEP='{::}'
  if [ -f "$HOME/Library/Application Support/Google/Chrome/Default/History" ]; then
    FZFPROMPT='Chrome> '
    command cp -f "$HOME/Library/Application Support/Google/Chrome/Default/History" /tmp/browser-history-fzf-temp
  elif [ -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" ]; then
    FZFPROMPT='Edge> '
    command cp -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" /tmp/browser-history-fzf-temp
  else
    echo "Chrome and Edge histories not found, exiting.."
    return 1
  fi
  FZFTEMP=$(sqlite3 -separator $SEP /tmp/browser-history-fzf-temp \
    "select substr(title, 1, $COLS), url
     from urls order by last_visit_time desc" |
  awk -F $SEP '{printf "%-'$COLS's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --prompt="$FZFPROMPT" --ansi --multi) && echo $FZFTEMP | sed 's#.*\(https*://\)#\1#' | xargs open
}
