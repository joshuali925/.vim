# shellcheck disable=1090,2015,2059,2148,2155,2164,2207
source ~/.vim/config/colors.sh  # LIGHT_THEME, LS_COLORS

export PATH="$HOME/.local/bin:$HOME/.local/lib/node-packages/bin:$HOME/.local/share/mise/shims:$PATH:$HOME/.local/share/nvim/mason/bin:$HOME/.vim/bin"
export EDITOR=nvim
export PAGER='less -RiM'  # less -RiM: --RAW-CONTROL-CHARS --ignore-case --LONG-PROMPT, -XF: exit if one screen, -S: nowrap, +F: tail file, -+F: always paginate
export RIPGREP_CONFIG_PATH="$HOME/.vim/config/.ripgreprc"
export FZF_COMPLETION_TRIGGER=\\
export FZF_DEFAULT_OPTS='--layout=reverse --cycle --height=50% --min-height=20 --bind=change:first --walker-skip=.git --info=inline-right --marker=▏ --pointer=▌ --prompt="▌ " --scrollbar="▌▐" --list-border --highlight-line --color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4,list-border:#bd93f9,preview-border:#50fa7b'
export FZF_CTRL_T_COMMAND='fd --type=f --strip-cwd-prefix --color=always --hidden --exclude=.git'
export FZF_CTRL_T_OPTS="--ansi --bind='\`:transform:if [[ {fzf:prompt} = \"▌ \" ]]; then if [[ -e .git ]] || git rev-parse --git-dir &>/dev/null; then echo \"change-prompt(no-ignore> )+reload(\$FZF_CTRL_T_COMMAND --follow --no-ignore || true)\"; else echo \"change-prompt(ls> )+reload(ls -1Ap --color=always --group-directories-first)\"; fi; elif [[ {fzf:prompt} = \"no-ignore> \" ]]; then echo \"change-prompt(git> )+reload({ git diff --name-only HEAD; git ls-files --others --exclude-standard; })\"; elif [[ {fzf:prompt} = \"git> \" ]]; then echo \"change-prompt(ls> )+reload(ls -1Ap --color=always --group-directories-first)\"; else echo \"change-prompt(▌ )+reload(\$FZF_CTRL_T_COMMAND)\"; fi' --bind='ctrl-p:transform:[[ \$FZF_PREVIEW_LABEL =~ cat ]] && echo \"change-preview(git log --color --graph --pretty=simple -- \{})+change-preview-label( log )\" || echo \"change-preview(bat --color=always --style=numbers -- \{})+change-preview-label( cat )\"'"
export FZF_ALT_C_COMMAND='ls -1Ap --color=always --group-directories-first 2> /dev/null'
export FZF_ALT_C_OPTS="--ansi --bind='tab:down,btab:up' --bind='\`:unbind(\`)+reload($FZF_CTRL_T_COMMAND || true)' --height=~40% --scheme=default"
export FZF_CTRL_R_OPTS="--bind='\`:toggle-sort,ctrl-r:toggle-raw,ctrl-y:execute-silent(echo -n {2..} | y)+abort' --header='\`: toggle sort | C-r: toggle raw | C-y: copy' --preview='bat --language=bash --color=always --plain <<< {2..}' --preview-window='wrap,40%'"
if [[ $LIGHT_THEME = 1 ]]; then  # https://github.com/jesseduffield/lazygit/issues/4550, specifying in .gitconfig cannot change theme dynamically
  export BAT_THEME=GitHub FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=light,query:238,fg:238,bg+:252,gutter:251,border:248"
else
  export BAT_THEME=OneHalfDark
fi

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
alias cp='cp -dRiv --reflink=auto --sparse=always'
alias mkdir='mkdir -pv'
alias ll='\ls -AlhF --color=auto --group-directories-first'
alias ls='ls -F --color=auto'
alias ls-ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias chmod\?='stat --printf "%a %n\n"'
alias bell='printf "\a"'
alias dateiso='date -u +"%Y-%m-%dT%H:%M:%SZ"'  # dateiso -d @<epoch-seconds>. to get epoch milliseconds: date +%s%3N
alias sudo='sudo '  # alias commands with space allows alias after command
alias xargs='xargs '
alias watch='watch '
alias viddy='viddy '
alias v='$EDITOR'
alias vi='\vim'
alias vii='\vim -u ~/.vim/config/mini.vim -i NONE'
alias vim='$EDITOR'
alias .env='findup .env >&2 && \env $(sed "/^#/d;s/^export //" "$(findup .env)" | xargs) '
alias venv='deactivate 2> /dev/null; findup .venv >&2 && source "$(findup .venv)/bin/activate" || { uv venv && mise set _.python.venv=".venv"; }'  # without uv: py -m venv .venv
alias py='env PYTHONSTARTUP=$HOME/.vim/config/pythonrc.py python3'
alias k='kubectl'
alias dc='docker compose'
alias lg='lazygit'
alias lzd='lazydocker'
alias ctop='docker run -e TERM=xterm-256color --rm -it --name ctop -v /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop'
alias tmux-save='~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias title='printf "$([[ -n $TMUX ]] && printf "\033Ptmux;\033")\e]0;%s\e\\$([[ -n $TMUX ]] && printf "\033\\")"'
alias 00='[[ -f ~/.vim/tmp/last_result ]] && cd "$(<~/.vim/tmp/last_result)"'
# shellcheck disable=2154
alias jsonflat="jq '[paths(scalars) as \$path | {\"key\": \$path | join(\".\"), \"value\": getpath(\$path)}] | from_entries'"
# shellcheck disable=2154
alias json2csv='jq -r "def flatten_object: . as \$in | reduce paths(scalars) as \$path ({}; . + { (\$path | join(\".\")): \$in | getpath(\$path) }); map(flatten_object) | (.[0] | keys) as \$cols | \$cols, (.[] | [.[\$cols[]]]) | @csv"'
alias jsonl2csv='json2csv -s'
alias rga='rg --text --no-ignore --search-zip --follow'
alias rg!="rg '❗'"
alias xcp="rsync -avihP --no-owner --no-group --delete --filter=':- .gitignore'"
alias rclone="env RCLONE_PROGRESS=true RCLONE_DELETE_EMPTY_SRC_DIRS=true rclone"
alias markdowns='if [[ ! -x ~/.local/bin/mdview ]]; then uv tool install md-viewer-py; fi && printf %s "$(getip):8081" | y && eval mdview --host 0.0.0.0'  # eval to avoid red syntax if not installed
alias http.server='filebrowser --database ~/.vim/tmp/filebrowser.db --disable-exec --noauth --address 0.0.0.0 --port 8000'
# shellcheck disable=2142
alias gradle-deps="./gradlew -q projects | { rg -o -r '\$1:dependencies' -- \"(?<=--- Project ')(:[^']+)\" || echo dependencies } | xargs -I@ sh -c 'echo @ >&2; ./gradlew @'"
alias yarn-audit="yarn audit --json | jq -s '[.[] | select(.type == \"auditAdvisory\") | .data.advisory | {module: .module_name, severity: .severity, cves: (.cves | join(\",\")), url: .url, vulnerable_versions: .vulnerable_versions, patched_versions: .patched_versions, installed: (.findings | map(.version) | unique | join(\",\"))}] | unique_by(.cves) | sort_by((if .severity == \"critical\" then 0 elif .severity == \"high\" then 1 elif .severity == \"moderate\" then 2 elif .severity == \"low\" then 3 else 4 end), .module) | [\"MODULE\",\"SEVERITY\",\"CVE\",\"INSTALLED\",\"VULNERABLE\",\"PATCHED\",\"URL\"], (.[] | [.module, .severity, .cves, .installed, .vulnerable_versions, .patched_versions, .url]) | @tsv' -r | column -t -s $'\\t'"
# shellcheck disable=2142
alias command-frequency="fc -l 1 | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | column -c3 -s \" \" -t | sort -nr | head -n 30 | nl"
# shellcheck disable=2142
alias command-frequency-with-args="fc -l 1 | awk '{\$1=\"\"; CMD[\$0]++;count++;}END { for (a in CMD)print CMD[a] \"\\t\" CMD[a]/count*100 \"%\\t\" a;}' | sort -nr | head -n 30 | nl | column -c3 -s \$'\\t' -t"

alias g='git -c color.status=always status -sb | head -1; git log --graph --pretty=simple --boundary --max-count 15 @ $(grref 2>/dev/null)'
alias ga='git add'
alias gau='git add --all --intent-to-add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -vv --sort=-committerdate -a'
alias gbl='git for-each-ref --sort=-committerdate refs/heads --format="%(align:50,left)%(HEAD)%(color:red)%(refname:short)%(end)%(color:yellow)%(objectname:short) %(color:green)(%(committerdate:relative))%(color:reset) - %(subject) %(color:bold blue)❪%(authorname)❫%(color:reset)"'
alias gc!='gc --amend'
alias gcs='gc --signoff'
alias gcl='git clone --filter=blob:none'
alias gcm='git checkout --merge --ignore-other-worktrees "$(git remote show origin | sed -n "/HEAD branch/s/.*: //p")"'  # checkout default branch in origin
alias gco='git checkout'
alias gcp='git cherry-pick -x'
alias gd='git diff'
alias gdst='git diff --staged'
gds() { if [[ $# -eq 0 ]]; then echo -e "\e[1;32mStaged\e[0m"; git diff --stat --staged; echo -e "\n\e[1;31mUnstaged\e[0m"; fi; git diff --stat "$@"; }
alias gf='git fetch'
alias gfa='git remote | xargs -L1 git fetch --filter=blob:none'
alias gpf='git remote get-url fork > /dev/null 2>&1 || { gra-fork && echo Added remote: fork; }; git push --force-with-lease fork $(gref)'
alias gsup='git remote | fzf --bind="tab:down,btab:up" | xargs -I {} git branch --set-upstream-to={}/$(git symbolic-ref --short HEAD)'
alias gl='git pull'
alias glg='git log --stat --graph --pretty=fuller'
alias glga='git log --graph --pretty=fuller --all'
alias glo='git log --graph --pretty=simple'
alias gloa='git log --color --graph --pretty=simple-iso --all | less -RiMXF -p $(git show -s --format=%h)'
glx() { git log --graph --decorate=short --date-order --color --pretty=format:'%C(bold blue)%h%C(reset)§%C(dim normal)(%cr)%C(reset)§%C(auto)%d%C(reset)§§%n§§§       %C(normal)%an%C(reset)%C(dim normal): %s%C(reset)' "${1:-$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || echo --all)}" HEAD | awk '{ split($0,arr,"§"); match(arr[2], /(\([0-9a-z ,]+\))/, rawtime); padlen=24+length(arr[2])-length(rawtime[1]); printf("%*s    %s %s %s\n", padlen, arr[2], arr[1], arr[3], arr[4]); }' | less -RiMXF -p "$([[ -n $1 ]] && git rev-parse --short "$(git merge-base HEAD "$1")" || git show -s --format=%h)"; }
alias gr='git remote'
alias gref='git symbolic-ref --short HEAD'
alias grref='git rev-parse --abbrev-ref --symbolic-full-name @{upstream}'  # remote ref
alias grl='git reflog --color --date=human-local --pretty=simple-ref'
alias gra='git remote add'
alias gra-fork="git remote add fork \"\$(git remote get-url origin | sed 's,^\(https://\|git@\)\([^:/]\+\)[:/][^/]\+/\([^/]\+\)/\?$,git@\2:joshuali925/\3,')\"; git remote -v"
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grv='git remote -v'
alias gs='git status'
alias gst='git stash'
alias gshow='git show --patch-with-stat --pretty=fuller --remerge-diff'
alias gcd='cd "$(git rev-parse --show-toplevel || echo ".")"'
alias gvf='FZF_DEFAULT_COMMAND="git ls-files --modified --others --exclude-standard" fzf --multi --bind="enter:become($EDITOR -- {+})"'

gc() {
  if [[ $# -eq 0 ]]; then git commit; return $?; fi
  local args=() arg message
  for arg in "$@"; do
    if [[ $arg != -* ]]; then message+="$arg "; else args+=("$arg"); fi
  done
  if [[ -n $message ]]; then args+=(-m "$message"); fi
  git commit "${args[@]}"
}

gcb() {
  if [[ $# -gt 0 ]]; then
    git checkout -b "$@" || git checkout --merge --ignore-other-worktrees "$@"  # with worktree add -f and checkout --ignore-other-worktrees, commits will be applied to all worktrees with the same branch (as they have the same .git file), but the working directory won't automatically change
    return $?
  fi
  # shellcheck disable=2016
  local branch fzftemp=$(git branch --color --sort=-committerdate --all | awk '/remotes\//{a[++c]=$0;next}1;END{for(i=1;i<=c;++i) print a[i]}' |
    fzf --ansi --scheme=history --reverse --preview-window=60% --toggle-sort=\` --header='Press ` to toggle sort' \
    --preview="git log -n 50 --color --graph --pretty=simple \$(sed 's/.* //' <<< {})" | sed "s/.* //")
  if [[ -z $fzftemp ]]; then return 1; fi
  if [[ $fzftemp = remotes/* ]]; then local remote="${fzftemp#remotes/}" && branch="${remote#[^\/]*/}"; else branch="$fzftemp"; fi  # remote: <remote>/<branch>; branch: <branch>
  if git show-ref --verify --quiet "refs/heads/$branch"; then  # <branch> exists, switch if tracking <remote> or create as <remote>-<branch>
    local tracking="$(git rev-parse --abbrev-ref "$branch@{upstream}" 2> /dev/null)"  # current tracking <remote'>/<branch'> for <branch>
    if [[ -z $remote ]] || [[ -z $tracking ]] || [[ $tracking = "$remote" ]]; then git checkout --merge --ignore-other-worktrees "$branch" && return $?; fi  # create <remote>-<branch> if <remote'> and <remote> are different, otherwise switch directly
    git show-ref --verify --quiet "refs/heads/${remote/\//-}" && git checkout "${remote/\//-}" || git checkout -b "${remote/\//-}" --track "$remote"
  else  # <branch> doesn't exist, create it
    [[ -n $remote ]] && git checkout --track "$remote" || git checkout "$branch"
  fi
}

gwt() {
  if [[ $# -eq 0 ]]; then
    local worktree=$(git worktree list | fzf | awk '{print $1}') && [[ -d $worktree ]] && cd "$worktree"
  elif [[ $1 != add ]]; then
    git worktree "$@"
  elif [[ $# -gt 2 ]]; then
    git worktree add -f "$@"
  else
    local prefix=${PWD##*/} branch=$(git symbolic-ref --short HEAD)
    git worktree add -f "../${prefix%-"$branch"}-$2" "$2"
  fi
}

glof() {
  git log --graph --color --pretty=simple --all "$@" |
    fzf --ansi --layout=default --height=100% --list-border=none --scheme=history --reverse --toggle-sort=\` --multi \
    --header='`: toggle sort | C-y: copy commit | C-r: toggle raw | C-p: toggle preview' \
    --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --paging=never' \
    --bind='ctrl-r:toggle-raw' \
    --bind='ctrl-p:toggle-preview,,:preview-down,.:preview-up' \
    --bind='ctrl-y:execute(echo {+} | grep -o "[a-f0-9]\{7,\}" | tac | tr "\n" " " | y)+abort' \
    --bind='enter:execute(grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --paging=always)'
}

grlf() {
  git reflog --color --date=human-local --pretty=simple-ref "$@" | awk '!x[$1]++' |
    fzf --ansi --layout=default --height=100% --list-border=none --scheme=history --reverse --toggle-sort=\` --multi \
    --header='`: toggle sort | C-e: diff to HEAD | C-y: copy commit | C-r: toggle raw | C-p: toggle log/diff preview' \
    --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git log --color --graph --pretty=simple' \
    --preview-label=' log ' \
    --bind='ctrl-r:toggle-raw' \
    --bind='ctrl-p:transform:[[ $FZF_PREVIEW_LABEL =~ log ]] && echo "change-preview-label( show )+change-preview(grep -o \"[a-f0-9]\\{7,\\}\" <<< \{} | xargs git show --patch-with-stat --color | delta --paging=never)" || echo "change-preview-label( log )+change-preview(grep -o \"[a-f0-9]\\{7,\\}\" <<< \{} | xargs git log --color --graph --pretty=simple)"' \
    --bind=',:preview-down,.:preview-up' \
    --bind='ctrl-e:execute(grep -o "[a-f0-9]\{7,\}" <<< {} | xargs -I@ git diff @..HEAD | delta --paging=always)' \
    --bind='ctrl-y:execute(echo {+} | grep -o "[a-f0-9]\{7,\}" | tac | tr "\n" " " | y)+abort' \
    --bind='enter:execute(grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --paging=always)'
}

tre() {
  find "${@:-.}" | sed 's;/;\t;g' | sort | sed 's;\t;/;g' | sed "s;[^-][^\/]*/;   │;g;s;│\([^ ]\);├── \1;;s;^ \+;;"
}

function = () {
  python -c "from math import *; __import__('pprint').pprint($*)"
}

termwrap() {
  nvim --clean -c 'set cmdheight=0 laststatus=0 shadafile=NONE' -c 'highlight Normal guifg=NONE guibg=NONE' -c 'autocmd TermClose * quitall!' -c "terminal $*" -c startinsert
}

st() {  # LANG is empty on some (RedHat) distros, set it to allow unicode/nerdfont display. Set basic PATH for commands invoked by tmux not through shell (e.g. new-window)
  ssh -t "$@" 'LANG=C.UTF-8 EDITOR=nvim PATH=$HOME/.local/bin:$PATH:$HOME/.vim/bin .vim/bin/tmux new -A -s 0'
}

tarcopy() {
  printf " printf $(XZ_OPT=-9e tar czf - "$@" | base64 | tr -d '\r\n') | base64 -d | tar xvz" | tee >(y) | wc -c | xargs echo Characters copied:
}

yy() {  # yazi supports --cwd-file=/dev/stdout, but it breaks opening vim in yazi
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" dir
  yazi "$@" --cwd-file="$tmp"
  if dir="$(<"$tmp")" && [[ -n $dir && $dir != "$PWD" ]]; then cd -- "$dir" > /dev/null; fi
  rm -f -- "$tmp"
}

csvq() {
  if [[ $# -eq 0 ]]; then echo -e "Usage: $0 <csv-file> [delimiter]" >&2; return 1; fi
  local file=$1 delimiter="${2:-,}" tmp="$(mktemp -t "csvq.XXXXXX.db")"  # litecli .import does not automatically create table from csv, workaround needs temp db
  sqlite3 "$tmp" -cmd '.mode csv' -cmd ".separator $delimiter" ".import $file t" && litecli --prompt "table:t> " --auto-vertical-output "$tmp"
  rm -f -- "$tmp"
}

size() {
  if [[ $1 = '--on-disk' ]]; then du -ah --max-depth=1 "${@:2}" | sort -hr; return $?; fi
  if [[ $1 = '--subdirs' ]]; then local args=("${@:2}"); else local args=(--max-depth=1 "$@"); fi
  du -ab "${args[@]}" | sort -nr | head -n 20 | awk 'function hr(bytes) { hum[1099511627776]="TiB"; hum[1073741824]="GiB"; hum[1048576]="MiB"; hum[1024]="kiB"; for (x = 1099511627776; x >= 1024; x /= 1024) { if (bytes >= x) { return sprintf("%8.3f %s", bytes/x, hum[x]); } } return sprintf("%4d     B", bytes); } { printf hr($1) "\t"; $1=""; print $0; }'
}

d() {  # show directory stack or download from URL
  if [[ $# -eq 0 ]]; then dirs -v | sed -n 2,11p; return $?; fi
  local wget_args=(--content-disposition) curl_args=(--remote-header-name)
  if [[ $1 = '-c' || $1 = '--continue' ]]; then shift && local wget_args=(--continue) curl_args=(-C -); fi
  if [[ $1 = -* ]]; then echo "Usage: $0 [[-c/--continue] <URL> [output-dir]]" >&2; return 1; fi
  if builtin command -v wget > /dev/null 2>&1; then
    wget "${wget_args[@]}" --tries 3 --directory-prefix "${2:-.}" "$1"
  elif builtin command -v curl > /dev/null 2>&1; then
    curl -f -LO "${curl_args[@]}" --retry 3 --retry-delay 5 --create-dirs --output-dir "${2:-.}" "$1"
  else
    echo 'wget or curl not found, exiting..' >&2; return 1
  fi
}

pscpu() {
  local ps_out pids pid pstree_flags pstree_out cwd
  if [[ $OSTYPE = darwin* ]]; then
    ps_out=$(ps -rwwAo user,pid,ppid,pcpu,pmem,time,command)
    pstree_flags='-wp'
  else
    ps_out=$(ps auxww --sort=-pcpu)
    pstree_flags='-Glps'
  fi
  if [[ $# -eq 0 ]]; then echo "$ps_out"; else grep -i "$@" <<<"$ps_out"; fi | head -n 11
  if [[ ! -x $(command -v pstree) ]]; then echo 'pstree not found (yum install -y psmisc).' >&2; return 1; fi
  if [[ $# -eq 0 ]]; then
    pids=($(sed -n '2,4p' <<< "$ps_out" | awk '{print $2}'))
  else
    pids=($(grep -i "$@" <<< "$ps_out" | awk '{print $2}'))
  fi
  for pid in "${pids[@]}"; do
    pstree_out=$(pstree "$pstree_flags" "$pid")
    if [[ $pstree_out =~ $pid ]]; then
      if [[ $OSTYPE = linux* && -r /proc/$pid ]]; then cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null) && printf '(\e[1;31m%s\e[0m) %s\n' "$pid" "$cwd"; fi
      head -n 8 <<< "$pstree_out" | grep --color -E "^|$pid"
    fi
  done
}

psmem() {
  local ps_out
  if [[ $OSTYPE = darwin* ]]; then
    ps_out=$(ps -mwwAo pid,rss,command)
  else
    ps_out=$(ps axwwo pid,rss,args --sort -size)
  fi
  if [[ $# -gt 0 ]]; then ps_out=$(grep -i "$@" <<< "$ps_out" | head -n 16); fi
  head -n 16 <<< "$ps_out" | awk '{ hr=$2/1024 ; printf("%7s %9.2f Mb\t",$1,hr) } { for ( x=3 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'
}

sudorun() {
  if [[ $# -eq 0 ]]; then echo 'Need a command to run.' >&2; return 1; fi
  local cmd=$1; shift
  if [[ ! -x $(command -v "$cmd") ]] && type "$cmd" | grep -q "$cmd is a \(shell \)\?function"; then
    echo -e "Running as bash function..\n" >&2
    sudo bash -c "$(declare -f "$cmd"); $cmd $*"
    return $?
  fi
  case $cmd in
    v|vi|vim) sudo TERM=xterm-256color "$(/usr/bin/which vim)" -u ~/.vim/config/mini.vim "$@" ;;
    *) TERM=xterm-256color EDITOR=vim XDG_CONFIG_HOME="$HOME/.config" sudo -E env PATH="$PATH" "$cmd" "$@" ;;
  esac
}

print-ascii() {
  local names=(NUL SOH STX ETX EOT ENQ ACK BEL BS TAB LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUB ESC FS GS RS US) off=0 i c v label
  if [[ -n $ZSH_VERSION ]]; then off=1; fi
  echo 'Dec Hex     Dec Hex     Dec Hex     Dec Hex     Dec Hex     Dec Hex     Dec Hex     Dec Hex'
  for i in {0..15}; do
    for c in {0..7}; do
      v=$((i + c*16))
      if ((v < 32)); then label="${names[v+off]}"
      elif ((v == 32)); then label=SPC
      elif ((v == 127)); then label=DEL
      else label=$(printf "\\$(printf '%o' $v)"); fi
      printf '%3d %02x %-3s ' "$v" "$v" "$label"
    done
    echo
  done
}

print-colors() {  # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797 https://github.com/jbranchaud/til/blob/b1994cfe2144193f46f8c61f20f9a583085ca0aa/unix/display-all-the-terminal-colors.md
  local x i a
  for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do printf "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done
  printf '\e[0m\n\nForeground 8 colors\n'
  printf "$(tput setaf 0) black $(tput setaf 1) red $(tput setaf 2) green $(tput setaf 3) yellow $(tput setaf 4) blue $(tput setaf 5) magenta $(tput setaf 6) cyan $(tput setaf 7) white $(tput sgr 0)"
  printf '\n\nBackground 8 colors\n'
  printf "$(tput setab 0) black $(tput setab 1) red $(tput setaf 0)$(tput setab 2) green $(tput setab 3) yellow $(tput setaf 7)$(tput setab 4) blue $(tput setab 5) magenta $(tput setaf 0)$(tput setab 6) cyan $(tput setab 7) white $(tput sgr 0)"
  printf '\n\nANSI 16 colors\n'
  printf ' \e[0;30mblack="\\e[0;30m" \e[0;31mred="\\e[0;31m"     \e[0;32mgreen="\\e[0;32m" \e[0;33myellow="\\e[0;33m"\n'
  printf ' \e[0;34mblue="\\e[0;34m"  \e[0;35mmagenta="\\e[0;35m" \e[0;36mcyan="\\e[0;36m"  \e[0;37mwhite="\\e[0;37m"\n'
  printf ' \e[0mno_color="\\e[0m"       \u2191 original 8 colors      \u2193 lighter 8 colors\n'
  printf ' \e[1;30mblack="\\e[1;30m" \e[1;31mred="\\e[1;31m"     \e[1;32mgreen="\\e[1;32m" \e[1;33myellow="\\e[1;33m"\n'
  printf ' \e[1;34mblue="\\e[1;34m"  \e[1;35mmagenta="\\e[1;35m" \e[1;36mcyan="\\e[1;36m"  \e[1;37mwhite="\\e[1;37m"\e[0m\n'
  printf '\nForeground 256 colors\n'
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' "$i" "$i"; (((i+3) % 18)) || printf '\e[0m\n'; done
  printf '\n\nBackground 256 colors\n'
  for i in {0..255}; do printf '\e[48;5;%dm%3d ' "$i" "$i"; (((i+3) % 18)) || printf '\e[0m\n'; done
  awk -v term_cols="$(tput cols || echo 80)" 'BEGIN{
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
  local arg
  for arg in "$@"; do
    if [[ -f $arg ]]; then
      xtract "$arg"
    else
      tar czvf "${arg%%/}.tar.gz" "$arg"
    fi
  done
}

X() {  # extract to a directory / compress without top directory
  local arg
  for arg in "$@"; do
    if [[ -f $arg ]]; then
      local dir="${arg%.*}"
      local filename="$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)_$arg"
      command mkdir -pv "$dir"
      command mv -i "$arg" "$dir/$filename"
      (cd "$dir" > /dev/null && xtract "$filename")
      command mv -n "$dir/$filename" "$arg"
    else
      tar czvf "${arg%%/}.tar.gz" -C "$arg" .
    fi
  done
}

path() {
  if [[ $# -eq 0 ]]; then
    echo -e "${PATH//:/\\n}"
  else
    type -a "$@"
    declare -f "$@" || true
  fi
}

findup() {
  if [[ $# -ne 1 ]]; then echo "Usage: $0 <file>" >&2; return 1; fi
  local dir=$PWD depth=0 rel
  while [[ ! -e $dir/$1 ]]; do
    if [[ $dir == / ]]; then return 1; fi
    dir=${dir%/*}
    dir=${dir:-/}
    ((depth++))
  done
  for ((i=0; i<depth; i++)); do rel+=../; done
  echo "$rel$1"
}

vx() {
  if [[ $# -eq 0 ]]; then echo -e "Usage: $0 <vim-commands>\nRun vim commands in pipe: echo foo | $0 '%s/foo/bar' 'put=execute(\\\"echo &tabstop\\\")'" >&2; return 1; fi
  ex -sn "${@/#/+}" +'%write! /dev/stdout | quit!' /dev/stdin
}

vf() {  # find files: vf; open files from pipe: fd | vf
  local IFS=$'\n'
  if [[ ! -t 0 ]] ; then
    # shellcheck disable=2046
    $EDITOR "$@" -- $(cat)
  else
    local fzftemp=($(FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND $*" FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi))
    # shellcheck disable=2128
    if [[ -n $fzftemp ]]; then $EDITOR -- "${fzftemp[@]}"; fi
  fi
}

vrg() {
  if [[ $# -eq 0 ]]; then [[ ! $(fc -ln -1) =~ ^rg* ]] && echo 'Need a string to search for.' >&2 || eval "v$(fc -ln -1)"; return $?; fi
  if [[ " $* " = *' --fixed-strings '* ]] || [[ " $* " = *' -F '* ]]; then local pattern="/\V$1"; else local pattern="/$1"; fi
  $EDITOR -q <(rg --vimgrep "$@") -c "$pattern"
}

rf() {  # livegrep https://github.com/junegunn/fzf/blob/HEAD/ADVANCED.md#ripgrep-integration, usage: rf [pattern] [flags], fzf-query: [pattern] -- [flags]
  local rest=() arg
  for arg in "$@"; do
    if [[ -n $skip_args ]]; then rest+=("$arg"); continue; fi
    case $arg in -*) rest+=("$arg") ;; *) local init_query="$arg"; local skip_args=1 ;; esac
  done
  local rg_prefix="rg --column --line-number --no-heading --color=always$([[ $# -gt 0 ]] && printf " %q" "${rest[@]}")"
  # `fzf < /dev/null` disables default fzf command, `: | fzf` does the same but breaks tmux current pane path on mac
  # quotes around `*` is required in shell but won't work in rf or snacks.picker. use pattern -- -g *.sh; `\s-- ` to search for ` -- `
  fzf --ansi --multi --layout=default --height=100% --list-border=none --disabled --delimiter=: --prompt='ripgrep> ' --query="${init_query:-}" --freeze-left 1 \
    --bind="start,change:transform:{ read -r pat; read -r flags; } < <(awk -F' -- ' '{gsub(/\\*/, \"\\\\*\", \$2); print \$1; print \$2}' <<<{q}) && printf 'change-header(C-s: toggle fzf | C-o: close fzf and open in editor | $rg_prefix %s -- %q)+reload:$rg_prefix %s -- %q\n' \"\$flags\" \"\$pat\" \"\$flags\" \"\$pat\"" \
    --bind="ctrl-s:transform:[[ {fzf:prompt} = 'ripgrep> ' ]] && echo 'unbind(change)+change-prompt(fzf:{q}> )+enable-search+clear-query' || echo 'change-prompt(ripgrep> )+disable-search+clear-query+reload($rg_prefix -- {q} || true)+rebind(change)'" \
    --bind="enter:execute(if [[ \$FZF_SELECT_COUNT -eq 0 ]]; then $EDITOR -c \"let @/='\$(awk -F ' -- ' '{print \$1}' <<<{q})'\" -c \"set hlsearch\" +{2} -- {1}; else $EDITOR -c \"let @/='\$(awk -F ' -- ' '{print \$1}' <<<{q})'\" -c \"set hlsearch\" +cw -q {+f}; fi)" \
    --bind="ctrl-o:become(if [[ \$FZF_SELECT_COUNT -eq 0 ]]; then $EDITOR -c \"let @/='\$(awk -F ' -- ' '{print \$1}' <<<{q})'\" -c \"set hlsearch\" +{2} -- {1}; else $EDITOR -c \"let @/='\$(awk -F ' -- ' '{print \$1}' <<<{q})'\" -c \"set hlsearch\" +cw -q {+f}; fi)" \
    --bind='tab:toggle+up,btab:toggle+down' \
    --preview='bat --color=always --highlight-line {2} -- {1}' \
    --preview-window='up,+{2}+3/3,~3' < /dev/null
}

rgi() {  # https://junegunn.github.io/fzf/tips/processing-multi-line-items/#ripgrep-multi-line-chunks, do not do livegrep as sed/perl processing is slow
  local arg
  for arg in "$@"; do [[ $arg != -* ]] && local search="-c 'let @/=\"$(printf '%q' "$arg")\"' -c 'set hlsearch'" && break; done
  rg --pretty "$@" 2>&1 | sed ':a;N;$!ba;s/\n\n/\x00/g' | fzf --ansi --read0 --height=100% --list-border=none --gap --bind="enter:execute(head -n 2 <<< {} | awk -F: 'NR==1 {file=\$1} NR==2 {print \"+\" \$1 \" -- \" file}' | xargs $EDITOR $search)" --bind='tab:down,btab:up'
}

z() {
  if [[ $# -eq 0 ]]; then
    local fzftemp rcwd=$(realpath "$PWD" || echo "$PWD")
    fzftemp=$(awk -F'|' -v now="$EPOCHSECONDS" -v cwd="$rcwd" '$1!=cwd {dx=now-$3; printf "%s\x01%.0f\n", $1, 10000*$2*(3.75/((0.0001*dx+1)+0.25))}' ~/.z | sort -nrk 2 -t $'\x01' | fzf --delimiter=$'\x01' --with-nth=1 --accept-nth=1 --ansi --scheme=history \
      --header='`: show recent directories under cwd | C-a: show all directories' --bind='tab:down,btab:up' \
      --bind="\`:change-prompt($rcwd/> )+reload:sort -nrk 3 -t '|' ~/.z | awk -F '|' -v cwd=\"$rcwd/\" '\$0~(\"^\"cwd) {print substr(\$1, length(cwd)+1)}'" \
      --bind="ctrl-a:change-prompt($rcwd/> )+reload(fd --strip-cwd-prefix --color=always --hidden --exclude=.git)") && z "$fzftemp"
  elif [[ -d $1 ]]; then cd -- "$1"
  elif [[ -f $1 ]]; then cd -- "$(dirname "$1")"
  else _z "$@"; fi
}

t() {  # create, restore, or switch tmux session
  local change current fzftemp
  if [[ -n $TMUX ]]; then
    if [[ $# -eq 0 ]]; then tmux-wait -; return $?; fi
    change='switch-client' && current=$(tmux display-message -p '#{session_name}')
  else
    change='attach-session'
  fi
  if [[ $# -gt 0 ]]; then
    [[ $1 = a ]] && tmux attach 2> /dev/null || tmux $change -t "$1" 2> /dev/null || (tmux new-session -d -s "$@" && tmux $change -t "$1")
    return $?
  fi
  fzftemp=$(tmux list-sessions -F '#{session_name}' 2> /dev/null | sed "/^$current$/d" | fzf --prompt='attach> ' --bind='tab:down,btab:up' --select-1 --exit-0)
  if [[ -n $fzftemp ]]; then tmux $change -t "$fzftemp"; return $?; fi
  fzftemp=$(FZF_DEFAULT_COMMAND='find ~/.local/share/tmux/resurrect -name "tmux_resurrect_*.txt" | sort -r' fzf --prompt='restore> ' --header='Press C-d to delete a session' --preview='cat {}' --bind='ctrl-d:execute(mv {} {}.bak)+reload(find ~/.local/share/tmux/resurrect -name "tmux_resurrect_*.txt")' --bind='tab:down,btab:up' --exit-0)
  if [[ -z $fzftemp ]]; then tmux; return $?; fi
  ln -sf "$fzftemp" ~/.local/share/tmux/resurrect/last && tmux new-session -d " tmux run-shell $HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh" && tmux attach-session
}

tmux-rerun() {
  if [[ $# -eq 0 ]]; then echo "Usage: $0 <command>" >&2; return 1; fi
  local pane
  for pane in $(tmux list-panes -a -f "#{==:#{pane_current_command},$1}" -F '#D'); do  # for index-based ref use #S:#I.#P (session:window.pane, <prefix>q to display pane numbers)
    tmux send-keys -t "${pane}" -X cancel 2>/dev/null
    tmux send-keys -t "${pane}" c-c
    tmux send-keys -t "${pane}" s-up enter
  done
}

tmux-wait() {
  if [[ $# -eq 0 ]]; then echo -e "Usage: $0 [<window-number>.]<pane-number>\n\tBlocks until the first pid of the provided pane in the current or provided window does not have any child processes\n\tUse <prefix>q to display pane numbers" >&2; return 1; fi
  if [[ $1 = *'.'* ]]; then local pane_id=$1; else local pane_id="$(tmux display-message -p '#S:#I').$1"; fi
  local ppid=$(tmux display-message -t "$pane_id" -p '#{pane_pid}')
  untildone "printf 'Waiting for command: ' && ! ps -o command= -p $(pgrep -P "$ppid") 2>/dev/null" && echo Command finished
}

man() {
  if [[ $# -eq 0 ]]; then
    local fzftemp
    fzftemp=$(command man -k . 2> /dev/null | awk 'BEGIN {FS=OFS="- "} /\([1|4]\)/ {gsub(/\([0-9]\)/, "", $1); if (!seen[$0]++) { print }}' | fzf --bind='tab:down,btab:up' --preview=$'echo {} | xargs -r man' --bind='enter:become(echo {1})') && man "$fzftemp"
  elif [[ $EDITOR = nvim ]]; then
    MANPAGER='nvim +Man\!' command man "$@"
  else
    command man "$@"
  fi
}

# shellcheck disable=2032
env() {
  if [[ $# -gt 0 || ! -t 1 ]]; then command env "$@"; return $?; fi
  # shellcheck disable=2016
  printenv | cut -d= -f1 | fzf --multi --preview='printenv {}' | xargs -r -I{} sh -c 'echo "{}=$(printenv "{}")"'
}

jo() {  # basic implementation of https://github.com/jpmens/jo
  local args=() arg
  for arg in "$@"; do
    args+=(--arg "$(cut -d= -f1 <<< "$arg")" "$(cut -d= -f2- <<< "$arg")")
  done
  jq -n "${args[@]}" '$ARGS.named'
}

untildone() {
  if [[ $# -eq 0 ]]; then
    echo -e "Usage: UNTILDONE_MAX_TRIES=<n> UNTILDONE_INTERVAL=<sec> $0 <command>\n\t$0 wget -c <url>  # wget until complete\n\t$0 'git pull; sleep 3599; false'  # git pull every hour\n\t$0 ! ps <pid>; ./run  # run after pid exits" >&2
    return 1
  fi
  local i=1 max_tries=${UNTILDONE_MAX_TRIES:-0} interval=${UNTILDONE_INTERVAL:-2}
  local start_time=$SECONDS
  tput sc
  while true; do
    local elapsed=$((SECONDS - start_time))
    local hours=$((elapsed / 3600)) mins=$(((elapsed % 3600) / 60)) secs=$((elapsed % 60))
    printf "\033[0;33mTry %d, elapsed %02d:%02d:%02d at %s.\033[0m\n" "$i" "$hours" "$mins" "$secs" "$(date +'%Y-%m-%dT%H:%M:%S%z')" >&2
    eval "$*" && break
    ((i+=1))
    if [[ $max_tries -gt 0 && $i -gt $max_tries ]]; then
      echo "Max tries ($UNTILDONE_MAX_TRIES) reached. Exiting." >&2
      return 1
    fi
    sleep "$interval"
    tput rc
    tput ed
  done
}

se() {
  local cmd reply
  case $1 in
    mise) eval "$(mise activate zsh)"; return $? ;;
    JAVA_HOME|java_home|javahome) cmd="export JAVA_HOME=\"$(mise where java)\"" ;;
    path) cmd="export PATH=\"$PWD:\$PATH\"" ;;
    proxy)
      local port=${2:-1080}
      cmd="export all_proxy=socks5://127.0.0.1:$port ALL_PROXY=socks5://127.0.0.1:$port no_proxy=localhost,127.0.0.1 NO_PROXY=localhost,127.0.0.1"
      if curl -s --connect-timeout 1 -x "http://127.0.0.1:$port" http://www.google.com > /dev/null 2>&1; then
        cmd+=" http_proxy=http://127.0.0.1:$port https_proxy=http://127.0.0.1:$port HTTP_PROXY=http://127.0.0.1:$port HTTPS_PROXY=http://127.0.0.1:$port"
      fi ;;
    aws)
      if [[ $2 = --region || $2 == -r ]]; then
        if [[ ! -e ~/.vim/tmp/aws-ec2-regions ]]; then
          aws ec2 describe-regions --query 'Regions[].{Region:RegionName}' --output text | sort > ~/.vim/tmp/aws-ec2-regions
        fi
        local region=$(< ~/.vim/tmp/aws-ec2-regions fzf)
        if [[ -n $region ]]; then
          sed -i "/^${region}$/d; 1i ${region}" ~/.vim/tmp/aws-ec2-regions
          export AWS_REGION=$region && echo "export AWS_REGION=$AWS_REGION"
        fi
      else
        if [[ -n $2 ]]; then local profile=$2; else local profile=$({ awk -F'[][]' '/^\[/ {print $2}' ~/.aws/credentials 2> /dev/null; awk -F'[][]' '/^\[profile / {gsub(/^profile /, "", $2); print $2}' ~/.aws/config 2> /dev/null; } | sort -u | fzf); fi  # faster than `aws configure list-profiles`
        if [[ -n $profile ]]; then export AWS_PROFILE=$profile && echo "export AWS_PROFILE=$AWS_PROFILE"; fi
      fi
      return $? ;;
    *) echo "Usage: $0 {mise|java_home|path|proxy [port]|aws [--region|-r|profile]}"; return 1 ;;
  esac
  echo "$cmd"; eval "$cmd"
  printf 'Write to .bashrc and .zshrc (y/N)? '
  read -r reply
  if [[ $reply = [Yy] ]]; then echo "$cmd" | tee -a ~/.bashrc ~/.zshrc && echo 'Appended to ~/.bashrc and ~/.zshrc'; fi
}

tldr() { curl "https://cheat.sh/${*// /+}"; }

getip() {
  if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [--private|ip|domain]" >&2
  elif [[ $# -eq 0 ]]; then
    if grep -q 'Amazon EC2' /sys/class/dmi/id/board_vendor 2> /dev/null; then
      curl -s -XPUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 1800' | xargs -I {} curl -s -H 'X-aws-ec2-metadata-token: {}' http://169.254.169.254/latest/meta-data/public-ipv4
    else
      curl -s https://checkip.amazonaws.com  # or ifconfig.me
    fi
  elif [[ $1 = --private ]]; then  # en0: wireless, en1: ethernet, en3: thunderbolt to ethernet
    builtin command -v ifconfig > /dev/null 2>&1 && ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' || ipconfig getifaddr en0 2> /dev/null || ipconfig getifaddr en1 2> /dev/null || hostname -I 2> /dev/null || ip route get 1.1.1.1 | awk '{print $7}'
  elif [[ $1 =~ ^[0-9.]+$ ]]; then
    curl -s "http://ip-api.com/line/$1"
  else
    curl -s "https://dns.google.com/resolve?name=$1" | if builtin command -v python > /dev/null 2>&1; then python -m json.tool --indent 2; else cat; fi
  fi
}

bin() {
  if [[ $1 != update ]]; then command bin "$@"; return $?; fi
  if [[ $# -eq 1 ]]; then
    TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/ ~/.tmux/plugins/tpm/bin/update_plugins all
    zsh -ic 'zimfw upgrade; zimfw update'
    if [[ -x $HOME/.local/bin/bin ]]; then command bin update; fi
    mise self-update && mise upgrade && mise prune -y && mise completion zsh > ~/.vim/config/zsh/completions/_mise && rm -f "${ZDOTDIR:-$HOME}"/.zcompdump*
    if [[ $OSTYPE = linux* ]] && mise which pm2 > /dev/null 2>&1; then
      npm install -g pm2
      pm2 update
      sudo -E "$(mise which node)" "$(mise which pm2)" unstartup systemd -u "$USER" --hp "$HOME"
      sudo -E "$(mise which node)" "$(mise which pm2)" startup systemd -u "$USER" --hp "$HOME"
    fi
    return $?
  fi
  local executable
  for executable in "${@:2}"; do
    local bin="$HOME/.local/bin/$executable" vim_bin="$HOME/.vim/bin/$executable"
    if [[ ! -x $vim_bin ]]; then command bin update "$executable"; continue; fi
    "$bin" --version || "$bin" -version || "$bin" -V || "$bin" version
    mkdir -p ~/config-backup
    command mv -v "$bin" "$HOME/config-backup/$executable.backup_$(date +%s)"
    "$vim_bin" --version || "$vim_bin" -version || "$vim_bin" -V || "$vim_bin" version
  done
}

docker-shell() {
  if [[ $1 = new || $1 = env ]]; then
    mkdir -p ~/.local/docker-share
    if [[ $1 = new ]]; then
      docker run -e TERM --network host -w /root -v ~/.local/docker-share:/docker-share -v ~/.vim:/root/.vim -it --rm alpine:edge sh -uelic 'apk add curl bash vim; .vim/bin/bashrc'
    else
      docker run -e TERM --network host -w /root -v ~/.local/docker-share:/docker-share -v ~/.vim:/root/.vim:ro -v ~/.local:/root/.local:ro -v ~/.config:/root/.config:ro -it --rm alpine:edge sh -uelic 'apk add curl bash vim; .vim/bin/bashrc'
    fi
    return $?
  fi
  local selected_id=$(docker ps | sed '1d' | awk '{printf "%s %-30s %s\n", $1, $2, $3}' | fzf --query="${1:-}" --height=100% --list-border=none --header='C-/: wrap | CR: shell | C-o: logs' --preview-window=up,70%,border-bottom,follow --preview='docker logs --follow --tail=1000 {1}' --bind='ctrl-/:change-preview-window(wrap|nowrap)' --bind='ctrl-o:execute:docker logs --follow --tail=10000 {1}')
  if [[ -z $selected_id ]]; then return 1; fi
  printf "\n → %s\n" "$selected_id"
  selected_id=$(awk '{print $1}' <<< "$selected_id")
  docker exec -it "$selected_id" /bin/bash || docker exec -it "$selected_id" sh || {
    printf '[docker-shell] sh failed, install busybox (y/N)? '; read -r REPLY
    if [[ $REPLY = [Yy] ]] && docker cp ~/.vim/bin/busybox "$selected_id":/busybox; then
      docker exec -it "$selected_id" /busybox mkdir -p /bin && docker exec -it "$selected_id" /busybox --install /bin || {
        local tmp=$(mktemp -d); mkdir -p "$tmp" && chmod 755 "$tmp" && docker cp "$tmp" "$selected_id":/bin; rm -rf "$tmp"  # create /bin if not exists
        docker cp ~/.vim/bin/busybox "$selected_id":/bin/ls; docker cp ~/.vim/bin/busybox "$selected_id":/bin/cat
      }
      docker exec -it "$selected_id" /busybox sh || echo 'Failed to start shell in container. Attaching volumes to alpine..' >&2 && docker run --rm -it --volumes-from "$selected_id" alpine:edge sh
    fi
  }
}

kube-shell() {
  FZF_DEFAULT_COMMAND='kubectl get pods --all-namespaces 2>&1' fzf --height=100% --list-border=none --info=inline --header-lines=1 \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " --header='C-/: wrap | CR: shell | C-o: open logs in editor' \
    --bind='ctrl-/:change-preview-window(wrap|nowrap)' \
    --bind='enter:execute:kubectl exec -it --namespace {1} {2} -- bash' \
    --bind="ctrl-o:execute:$EDITOR <(kubectl logs --all-containers --namespace {1} {2})" \
    --preview-window=up,70%,border-bottom,follow --preview='kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}'
}

pm2() {
  if [[ $# -gt 0 || ! -t 1 ]]; then command pm2 "$@"; return $?; fi
  local get_state='local IFS=$'\''\n'\'' app_list=$(pm2 list -m) map=() names ids app_status && names=($(echo "$app_list" | awk '\''/^\+---/{sub("+--- ", ""); print}'\'')) && ids=($(echo "$app_list" | awk '\''/^pm2 id : /{sub("pm2 id : ", ""); print}'\'')) && app_status=($(echo "$app_list" | awk '\''/^status : /{sub("status : ", ""); print}'\'')) && for ((i=1; i<=${#ids[@]}; i++)); do if [[ ${app_status[i]} = online ]]; then map+=("${ids[i]} : \e[0;32m${names[i]}\e[0m"); else map+=("${ids[i]} : \e[0;31m${names[i]} [${app_status[i]}]\e[0m"); fi; done && printf "%b\n" "${map[@]}"'
  FZF_DEFAULT_COMMAND=$get_state fzf --ansi --height=100% --list-border=none --header='C-/: wrap | CR: logs | C-e: start | C-t: stop | C-r: restart' \
    --bind='ctrl-/:change-preview-window(wrap|nowrap)' \
    --bind="ctrl-e:execute(pm2 start {1} && sleep 1)+reload($get_state)" --bind="ctrl-t:execute(pm2 stop {1} && sleep 1)+reload($get_state)" \
    --bind="ctrl-r:execute(pm2 restart {1} && sleep 1)+reload($get_state)" --bind="enter:become(pm2 logs --raw --lines 60000 -- {1})" \
    --preview-window=up,70%,border-bottom,follow --preview='pm2 logs --raw --lines 10000 -- {1}'
}

theme() {  # locally toggles wezterm theme, remotely updates configs to match terminal theme
  if [[ -n $WEZTERM_EXECUTABLE ]]; then
    grep -q 'local light_theme = false' ~/.vim/config/wezterm.lua && export LIGHT_THEME=1 || export LIGHT_THEME=0
    sed -i "s/\(local light_theme = \)\(true\|false\)/\1$([[ $LIGHT_THEME = 1 ]] && echo 'true' || echo 'false')/" ~/.vim/config/wezterm.lua
  else
    sed -i "s/LIGHT_THEME:-[0-9]/LIGHT_THEME:-$(bash -c "[[ -n \$TMUX ]] && read -rs -d \\\\ -p \$'\\033Ptmux;\\033\\e]11;?\\e\\\\\\033\\\\' osc11 || read -rs -d \\\\ -p \$'\\e]11;?\\e\\\\' osc11 && printf %q \"\$osc11\" | awk '{match(\$0, /rgb:([0-9a-f]+)\\/([0-9a-f]+)\\/([0-9a-f]+)/, arr); if (strtonum(\"0x\"arr[1]) > 32639 && strtonum(\"0x\"arr[2]) > 32639 && strtonum(\"0x\"arr[3]) > 32639) print \"1\"; else print \"0\"}'")/" ~/.vim/config/colors.sh
    unset LIGHT_THEME
  fi
  source ~/.vim/config/common.sh
  if [[ -n $TMUX ]]; then tmux set-environment -ug LIGHT_THEME; fi
}

.install() {  # declare as function for zsh completion
  ~/.vim/install.sh install "$@"
}

.vim-disable-binary-downloads() {
  export DOT_VIM_LOCAL_BIN=1
  export PATH="${PATH//.vim\/bin/.vim/local-bin}"
  export FZF_DEFAULT_COMMAND="command find -L . -mindepth 1 \\( -path '*/.git' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune -o -type f -print -o -type l -print 2> /dev/null | cut -b3-"
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
}

if [[ -n $DOT_VIM_LOCAL_BIN ]]; then .vim-disable-binary-downloads; fi

# ====================== MacOS ==========================
if [[ $OSTYPE = darwin* ]]; then
  alias idea='open -na "IntelliJ IDEA Ultimate.app" --args'
  alias ideace='open -na "IntelliJ IDEA CE.app" --args'
  alias refresh-icon-cache='rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock'
  alias toggle-dark-theme="osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
  alias last-sleeps='pmset -g log | grep "Clamshell Sleep" | tail'
  browser-history() {
    local cols=$((COLUMNS - 26)) sep='{::}' fzftemp fzfprompt histfile=/tmp/browser-history-fzf.db
    if [[ -f "$HOME/Library/Application Support/Google/Chrome/Default/History" ]]; then
      fzfprompt='Chrome> '
      histfile="$HOME/Library/Application Support/Google/Chrome/Default/browser-history-fzf.db"
      if [[ ! -f $histfile ]]; then command cp "$HOME/Library/Application Support/Google/Chrome/Default/History" "$histfile"; fi
      command cp -f "$HOME/Library/Application Support/Google/Chrome/Default/History" /tmp/browser-history-fzf.db
      sqlite3 "$histfile" 'attach "/tmp/browser-history-fzf.db" as toMerge; BEGIN;
      INSERT OR REPLACE INTO urls SELECT t.* FROM toMerge.urls t LEFT JOIN urls m ON t.id = m.id
      WHERE m.id IS NULL OR (m.id IS NOT NULL AND m.last_visit_time <> t.last_visit_time); COMMIT; detach toMerge;'
    elif [[ -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" ]]; then
      fzfprompt='Edge> '
      command cp -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" /tmp/browser-history-fzf.db
    else
      echo "Chrome and Edge histories not found, exiting.."
      return 1
    fi
    sqlite3 -separator $sep "$histfile" "select substr(title, 1, $cols), datetime((last_visit_time/1000000) - 11644473600, 'unixepoch', 'localtime'), substr(url, 1, 200) from urls order by last_visit_time desc" | awk -F $sep '{printf "%-'$cols's \x1b[32m%s\n\x1b[36m%s\x1b[m\0", $1, $2, $3}' |
      fzf --ansi --read0 --multi --height=100% --list-border=none --tiebreak=index --scheme=history --prompt="$fzfprompt" \
      --header='`: to toggle sort | C-o: open | C-r: toggle raw' \
      --bind=\`:toggle-sort \
      --bind='ctrl-r:toggle-raw' \
      --bind='ctrl-o:execute(awk "NR==2" <<< {} | xargs -r open)' |
      awk 'NR==2' | xargs -r open
  }
elif [[ $OSTYPE = linux-android ]]; then
  alias pr='proot -b $PREFIX/etc/resolv.conf:/etc/resolv.conf -b $PREFIX/etc/tls:/etc/ssl '  # or termux-chroot. ref: https://github.com/pocketbase/pocketbase/discussions/4030#discussioncomment-12814598
fi
