source ~/.vim/config/z.sh
source ~/.vim/config/colors.sh  # LIGHT_THEME, LS_COLORS, LF_ICONS
[ -s "$HOME/.asdf/asdf.sh" ] && ASDF_DIR=$HOME/.asdf source ~/.asdf/asdf.sh

export PATH="$HOME/.local/bin:$HOME/.local/lib/node-packages/node_modules/.bin:$PATH:$HOME/.vim/bin"
export EDITOR=nvim
export BAT_PAGER="less -RiM"  # less -RiM: --RAW-CONTROL-CHARS --ignore-case --LONG-PROMPT, -XF: exit if one screen, -S: nowrap, +F: tail file
export BAT_THEME=OneHalfDark
export RIPGREP_CONFIG_PATH="$HOME/.vim/config/.ripgreprc"
export FZF_COMPLETION_TRIGGER=\\
export FZF_DEFAULT_OPTS='--layout=reverse --height=40% --bind=change:top --info=inline --scrollbar "▌▐" --border=thinblock --preview-window=border-thinblock --color=fg:#f8f8f2,bg:#282a3d,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4,preview-bg:#242532'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='fd --type=f --strip-cwd-prefix --hidden --exclude=.git --color=always'
export FZF_CTRL_T_OPTS="--ansi --bind='\`:unbind(\`)+reload($FZF_CTRL_T_COMMAND --no-ignore || true)'"
export FZF_ALT_C_COMMAND='command ls -1Ap --color=always 2> /dev/null'
export FZF_ALT_C_OPTS="--ansi --bind='tab:down,btab:up' --bind='\`:unbind(\`)+reload($FZF_CTRL_T_COMMAND || true)'"
export FZF_PREVIEW_COMMAND='bat --color=always --style=numbers --line-range :50 {}'
if [ "$LIGHT_THEME" = 1 ]; then
  export BAT_THEME=GitHub
  export DELTA_THEME=light-theme
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=light,query:238,fg:238,bg:253,bg+:252,gutter:251,border:248,preview-bg:254"
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
alias cp='cp -riv'
alias mkdir='mkdir -pv'
alias ll='ls -AlhF --color=auto --group-directories-first'
alias ls='ls -F --color=auto'
alias l='exa -lF --git --color=always --color-scale --icons --header --group-directories-first --time-style=long-iso --all'
alias ls-ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias chmod\?='stat --printf "%a %n \n"'
alias bell='echo -n -e "\a"'
alias escape="sed 's/\\([\"\\]\\)/\\\\\\1/g'"  # escape "\ with backslash
alias dateiso='date -u +"%Y-%m-%dT%H:%M:%SZ"'  # dateiso -d @<epoch-seconds>
alias sudo='sudo '
alias less='less -RiM'
alias v='$EDITOR'
alias vi='\vim'
alias vii='\vim -u ~/.vim/config/mini.vim -i NONE'
alias vlf='\vim +Explore'
alias vim='$EDITOR'
alias .env='findup .env >&2 && env $(grep -v "^#" "$(findup .env)" | xargs)'
alias venv='deactivate 2> /dev/null; findup venv >&2 || python3 -m venv venv; source "$(findup venv)/bin/activate"'
alias gvenv='[ ! -d "$HOME/.local/lib/venv" ] && python3 -m venv "$HOME/.local/lib/venv"; source "$HOME/.local/lib/venv/bin/activate"'
alias gnpm='npm --prefix ~/.local/lib/node-packages'
alias py='env PYTHONSTARTUP=$HOME/.vim/config/pythonrc.py python3'
alias lg='lazygit'
alias lzd='lazydocker'
alias lf='lf -last-dir-path="$HOME/.vim/tmp/lf_dir"'
alias ctop='TERM="${TERM/#tmux/screen}" ctop'  # TODO https://github.com/bcicen/ctop/issues/263
alias tmux-save='~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias 0='[ -f "$HOME/.vim/tmp/lf_dir" ] && cd "$(cat "$HOME/.vim/tmp/lf_dir")"'
alias q='q --output-header --pipe-delimited-output --beautify --delimiter=, --skip-header'
alias q-="up -c \"\\\\\$(alias q | sed \"s/[^']*'\\(.*\\)'/\\1/\") 'select * from -'\""
alias rga='rg --text --no-ignore --search-zip --follow'
alias rg!="rg '❗'"
alias xcp="rsync -aviHKhSPz --no-owner --no-group --one-file-system --delete --filter=':- .gitignore'"
alias fpp='if [ -t 0 ] && [ $# -eq 0 ] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval "$(fc -ln -1 | sed "s/^rg /rg --vimgrep /")" | command fpp; else command fpp; fi'
alias http.server='filebrowser --database $HOME/.vim/tmp/filebrowser.db --disable-exec --noauth --address 0.0.0.0 --port 8000'
alias command-frequency="fc -l 1 | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | column -c3 -s \" \" -t | sort -nr | head -n 30 | nl"
alias command-frequency-with-args="fc -l 1 | awk '{\$1=\"\"; CMD[\$0]++;count++;}END { for (a in CMD)print CMD[a] \"\\t\" CMD[a]/count*100 \"%\\t\" a;}' | sort -nr | head -n 30 | nl | column -c3 -s \$'\\t' -t"

alias ga='git add'
alias gau='git add -u'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -vv --sort=-committerdate -a'
alias gbl='git for-each-ref --sort=-committerdate refs/heads --format="%(HEAD)%(color:yellow)%(refname:short)|%(color:green)%(committerdate:relative)|%(color:red)%(objectname:short)%(color:reset) - %(subject) %(color:bold blue)<%(authorname)>%(color:reset)" --color | column -ts"|"'
alias gc!='gc --amend'
alias gcs='gc --signoff'
alias gcs!='gc --signoff --amend'
alias gcgpg='export GPG_TTY=$(tty) && git commit --gpg-sign --signoff -m'
alias gcf='git config --list'
alias gcl='git clone'
alias gclo='git clone --filter=blob:none'
alias gcm='git checkout "$(git remote show origin | sed -n "/HEAD branch/s/.*: //p")"'  # checkout default branch in origin
alias gco='git checkout'
alias gcp='git cherry-pick -x'
alias gd='git diff'
alias gds='echo -e "\e[1;32mStaged\e[0m"; git diff --stat --staged; echo -e "\n\e[1;31mUnstaged\e[0m"; git diff --stat'
alias gdst='git diff --staged'
alias gdt='GIT_EXTERNAL_DIFF=difft git diff'
alias gdd='GIT_PAGER="delta --line-numbers --navigate --side-by-side" git diff'
alias gdf='GIT_PAGER="diff-so-fancy | \less --tabs=4 -RiMXF" git diff'
alias gdw='GIT_PAGER="diff-so-fancy | \less --tabs=4 -RiMXF" git diff --word-diff=color --ignore-all-space'
alias gf='git fetch'
alias gfa='git remote | xargs -L1 git fetch --filter=blob:none --prune'
alias ggl='git pull origin $(gref)'
alias gpf='git remote get-url fork > /dev/null 2>&1 || { gra-fork && echo Added remote: fork }; git push fork $(gref)'
alias gsup='git remote | fzf --bind="tab:down,btab:up" | xargs -I {} git branch --set-upstream-to={}/$(git symbolic-ref --short HEAD)'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph --pretty=fuller'
alias glgga='git log --graph --pretty=fuller --all'
alias glo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gloo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --max-count 10'
alias gloa='git log --color --graph --abbrev-commit --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ci)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)" --all'
alias glx="git log --all --graph --decorate=short --date-order --color --pretty=format:\"%C(bold blue)%h%C(reset)§%C(dim normal)(%cr)%C(reset)§%C(auto)%d%C(reset)§§%n§§§       %C(normal)%an%C(reset)%C(dim normal): %s%C(reset)\" | awk '{ split(\$0,arr,\"§\"); match(arr[2], /(\\([0-9a-z ,]+\\))/, rawtime); padlen=24+length(arr[2])-length(rawtime[1]); printf(\"%*s    %s %s %s\\n\", padlen, arr[2], arr[1], arr[3], arr[4]); }' | \less -RiMXF -p \$(git show -s --format=%h)"
alias gm='git merge'
alias gma='git merge --abort'
alias gmt='git mergetool --no-prompt'
alias gmerge-preview-log='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit HEAD..'  # commits in target but not in HEAD (will be merged with git merge target)
gmerge-preview-diff() { git diff HEAD..."$@"; }  # diff between target and the common ancestor of HEAD and target
gmissing() { git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --cherry-pick --right-only HEAD..."$@"; }  # commits in target but not in HEAD and not cherry-picked to HEAD
alias gr='git remote'
alias gref='git symbolic-ref --short HEAD'
alias grref='git rev-parse --abbrev-ref --symbolic-full-name @{upstream}'  # remote ref
alias grl='git reflog --color --date=human-local --pretty=format:"%Cred%h%Creset %C(037)%gD:%Creset %gs%Creset%C(auto)%d%Creset"'
alias gra='git remote add'
alias gra-fork="git remote add fork \"\$(git remote get-url origin | sed 's,^\(https://\|git@\)\([^:/]\+\)[:/][^/]\+/\([^/]\+\)/\?$,git@\2:joshuali925/\3,')\"; git remote -v"
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias greset-to-remote='git stash push --message "greset-to-remote temporary stash"; git reset --hard @{upstream}'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grv='git remote -v'
alias gs='git status'
alias gsall="find . -type d -name .git -execdir bash -c 'echo -e \"\\033[1;32m\"repo: \"\\033[1;34m\"\$([ \$(pwd) == '\$PWD' ] && echo \$(basename \$PWD) \"\\033[1;30m\"\(current directory\) || realpath --relative-to=\"'\$PWD'\" .) \"\\033[1;30m\"- \"\\033[1;33m\"\$(git symbolic-ref --short HEAD)\"\\033[1;30m\"\$(git log --pretty=format:\" (%cr)\" --max-count 1)\"\\033[0m\"; git status -s' \\;"
alias gss='git status -sb'
alias gst='git stash'
alias gsts='git stash; git stash apply'
alias gshow='git show --patch-with-stat --pretty=fuller'
alias gcount='git shortlog -sn'
alias gtree='git ls-files | tree --fromfile'
alias gwt='git worktree'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gunignore='git update-index --no-assume-unchanged'
alias gexclude='cat >> "$(git rev-parse --show-toplevel)/.git/info/exclude" <<<'
alias gexcluded='grep -v "^# " "$(git rev-parse --show-toplevel)/.git/info/exclude"'
gunexclude() { sed -i "/^${*//\//\\/}\$/d" "$(git rev-parse --show-toplevel)/.git/info/exclude"; local r=$?; gexcluded; return $r; }
alias gpristine='git stash push --include-untracked --message "gpristine temporary stash"; git reset --hard && git clean -fdx'
alias gunshallow='git remote set-branches origin "*" && git fetch -v && echo -e "\nRun \"git fetch --unshallow\" to fetch all history"'
alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit --signoff --no-verify -m "--wip--"'
alias gunwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
alias gwhatchanged='git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --stat $(git rev-parse --abbrev-ref --symbolic-full-name @{upstream})..HEAD  # what will be pushed'
alias gwhatsnew='git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --stat ORIG_HEAD...HEAD  # what was pulled'
alias gwhere='echo -e "Previous tag:\n  $(git describe --tags --abbrev=0)\nBranches containing HEAD: $(git branch --color -a --contains HEAD)"'
alias gsize='git rev-list --objects --all | git cat-file --batch-check="%(objecttype) %(objectname) %(objectsize) %(rest)" | sed -n "s/^blob //p" | sort --numeric-sort --key=2 | cut -c 1-12,41- | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest'  # use "git obliterate <filepath>; git gc --prune=now --aggressive" to remove, or https://rtyley.github.io/bfg-repo-cleaner
alias gforest='git foresta --style=10 | \less -RiMXF'
alias gforesta='git foresta --style=10 --all | \less -RiMXF -p $(git show -s --format=%h)'
alias gpatch='\vim -u ~/.vim/config/mini.vim -i NONE +startinsert patch.diff && git apply patch.diff && rm patch.diff'
alias gls="\ls -A --group-directories-first -1 | while IFS= read -r line; do git log --color --format=\"\$(\ls -d -F --color \"\$line\") =} %C(bold black)▏%Creset%Cred%h %Cgreen%cr%Creset =} %C(bold black)▏%C(bold blue)%an %Creset%s%Creset\" --abbrev-commit --max-count 1 HEAD -- \"\$line\"; done | awk -F'=}' '{ nf[NR]=NF; for (i = 1; i <= NF; i++) { cell[NR,i] = \$i; gsub(/\033\[([[:digit:]]+(;[[:digit:]]+)*)?[mK]/, \"\", \$i); len[NR,i] = l = length(\$i); if (l > max[i]) max[i] = l; } } END { for (row = 1; row <= NR; row++) { for (col = 1; col < nf[row]; col++) printf \"%s%*s%s\", cell[row,col], max[col]-len[row,col], \"\", OFS; print cell[row,nf[row]]; } }'"

tre() { find "${@:-.}" | sort | sed "s;[^-][^\/]*/;   │;g;s;│\([^ ]\);├── \1;;s;^ \+;;"; }
st() { ssh -t "$@" '.vim/bin/tmux new -A -s 0'; }

gc() {
  [ "$#" -eq 0 ] && { git commit --signoff -v; return $?; }
  local args=() message
  for arg in "$@"; do
    [[ "$arg" != -* ]] && message+="$arg " || args+=("$arg")
  done
  [ -n "$message" ] && args+=(-m "$message")
  git commit "${args[@]}"
}

gcb() {
  if [ "$#" -gt 0 ]; then
    git checkout -b "$@" || git checkout "$@"
    return $?
  fi
  local fzftemp=$(git branch --color --sort=-committerdate --all |
    awk '/remotes\//{a[++c]=$0;next}1;END{for(i=1;i<=c;++i) print a[i]}' |
    fzf --height=50% --min-height=20 --ansi --scheme=history --reverse --preview-window=60% --toggle-sort=\` \
    --header='Press ` to toggle sort' \
    --preview='git log -n 50 --color --graph --pretty=format:"%Cred%h%Creset - %Cgreen(%cr)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset" --abbrev-commit $(sed "s/.* //" <<< {})' | sed "s/.* //")
  [ -z "$fzftemp" ] && return 1
  local remote="${fzftemp#remotes/}"  # <remote>/<branch>
  if git show-ref --verify --quiet "refs/heads/${remote#[^\/]*/}"; then  # <branch> exists, switch if tracking <remote> or create as <remote>-<branch>
    local tracking="$(git rev-parse --abbrev-ref "${remote#[^\/]*/}@{upstream}" 2> /dev/null)"  # current tracking <remote'>/<branch'> for <branch>
    [ -n "$tracking" ] && [ "$tracking" != "$remote" ] && git checkout -b "${remote/\//-}" --track "$remote" || git checkout "${remote#[^\/]*/}"
  else  # <branch> doesn't exist, create it
    git checkout --track "$remote"
  fi
}

glof() {
  git log --graph --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit "$@" |
    fzf --height=50% --min-height=20 --ansi --scheme=history --reverse --toggle-sort=\` --multi \
    --header='Press ` to toggle sort, <C-y> to copy commit, <C-p> , . to control preview' \
    --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --paging=never' \
    --bind='ctrl-p:toggle-preview,,:preview-down,.:preview-up' \
    --bind='ctrl-y:execute(echo {+} | grep -o "[a-f0-9]\{7,\}" | tac | tr "\n" " " | y)+abort' \
    --bind='enter:execute(grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --line-numbers --navigate)'
}

grlf() {
  git reflog --color --date=human-local --pretty=format:"%Cred%h%Creset %C(037)%gD:%Creset %gs%Creset%C(auto)%d%Creset" "$@" | awk '!x[$1]++' |
    fzf --height=50% --min-height=20 --ansi --scheme=history --reverse --toggle-sort=\` --multi \
    --header='Press ` to toggle sort, <C-y> to copy commit, <C-p> , . to control preview' \
    --preview='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --paging=never' \
    --bind='ctrl-p:toggle-preview,,:preview-down,.:preview-up' \
    --bind='ctrl-y:execute(echo {+} | grep -o "[a-f0-9]\{7,\}" | tac | tr "\n" " " | y)+abort' \
    --bind='enter:execute(grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --patch-with-stat --color | delta --line-numbers --navigate)'
}

grg() {
  if [ "$#" -eq 0 ]; then echo "Usage: $0 [--reflog] [--regex] <text> [<git-log-args>]" >&2; return 1; fi
  while [ "$#" -ne 0 ]; do
    case $1 in
      --reflog) local cmd=reflog; shift ;;
      --regex) local search=-G; shift ;;
      --) shift; break ;;
      *) break ;;
    esac
  done
  git "${cmd:-log}" --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --regexp-ignore-case "${search:--S}" "$@" | fzf --height=50% --min-height=20 --ansi --preview="grep -o \"[a-f0-9]\\{7,\\}\" <<< {} | xargs git show --patch-with-stat --color | delta --paging=never" --bind=',:preview-down,.:preview-up' --bind='tab:down,btab:up' --bind="enter:execute(grep -o \"[a-f0-9]\\{7,\\}\" <<< {} | xargs -I{} git show --patch-with-stat --color {} | DELTA_PAGER=\"$BAT_PAGER --pattern='$1'\" delta --line-numbers)"
}

gvf() {  # find file in all commits, git log takes glob: gvf '*filename*'
  local root=$(git rev-parse --show-toplevel || echo ".")
  local filepath=$(git log --pretty=format: --name-only --all "$@" | awk NF | sort -u | fzf --height=50% --min-height=20 --ansi --multi --preview='git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --full-history -- '"${root}"'/{}')
  if [ -n "$filepath" ]; then
    local sha=$(git log --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --full-history -- "${root}/${filepath}" | fzf --height=50% --min-height=20 --ansi --preview="grep -o \"[a-f0-9]\\{7,\\}\" <<< {} | xargs -I{} git show {} -- ${root}/${filepath} | delta --paging=never" --bind=',:preview-down,.:preview-up' | grep -o "[a-f0-9]\{7,\}")
    if [ -n "$sha" ]; then
      echo -e "\033[0;35mgit show $sha:$filepath\033[0m" >&2
      git show "$sha:$filepath" | $EDITOR - -c "file $sha:$filepath" -c 'filetype detect'
    fi
  fi
}

gr-toggle-url() {
  local pattern='s,^\(https://\|git@\)\([^:/]\+\)[:/],' remote="${1:-origin}" url="$(git remote get-url "${1:-origin}")"
  grep -q '^https://' <<< "$url" && pattern="${pattern}git@\\2:," || pattern="${pattern}https://\\2/,"
  git remote set-url "$remote" "$(sed "$pattern" <<< "$url")"
  git remote -v
}

gpr() {
  if [ "$#" -lt 1 ]; then echo "Usage: $0 {PR-number|PR-URL} [remote]" >&2; return 1; fi
  local pr=${1##*/}
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    local repo=${1%/pull/*}
    git clone --filter=blob:none "$repo" "${repo##*/}-$pr"
    cd "${repo##*/}-$pr" > /dev/null || return 1
  fi
  git stash push --include-untracked --message 'git PR temporary stash'
  git fetch "${2:-origin}" "pull/$pr/head" && { git branch "pr/$pr" 2> /dev/null; git checkout "pr/$pr" && git reset --hard FETCH_HEAD; }
}

gh-backport() {
  if [ "$#" -ne 1 ]; then echo "Usage: $0 <SHA>" >&2; return 1; fi
  local sha=$1 args=()
  if [ -f ".github/PULL_REQUEST_TEMPLATE.md" ]; then
    args+=(--body-file .github/PULL_REQUEST_TEMPLATE.md)
  fi
  git cherry-pick -x "$sha" && git push fork "$(gref)" -f && gh pr create --title "[$(gref)] $(git log -n 1 --pretty=format:%s "$sha")" --base "$(gref)" "${args[@]}"
}

size() {
  [ "$1" = '--on-disk' ] && { du -ah --max-depth=1 "${@:2}" | sort -hr; return $?; }
  [ "$1" = '--subdirs' ] && local args=("${@:2}") || local args=(--max-depth=1 "$@")
  du -ab "${args[@]}" | sort -nr | head -n 20 | awk 'function hr(bytes) { hum[1099511627776]="TiB"; hum[1073741824]="GiB"; hum[1048576]="MiB"; hum[1024]="kiB"; for (x = 1099511627776; x >= 1024; x /= 1024) { if (bytes >= x) { return sprintf("%8.3f %s", bytes/x, hum[x]); } } return sprintf("%4d     B", bytes); } { printf hr($1) "\t"; $1=""; print $0; }'
}

d() {  # show directory stack or download from URL (does not continue download): d [<URL> [output-dir]]
  if [ "$#" -eq 0 ]; then dirs -v | head -10; return $?; fi
  if builtin command -v wget > /dev/null 2>&1; then
    wget --content-disposition --tries 3 --directory-prefix "${2:-.}" "$1"
  elif builtin command -v curl > /dev/null 2>&1; then
    curl -f -LO --remote-header-name --retry 3 --retry-delay 5 --create-dirs --output-dir "${2:-.}" "$1"
  else
    echo 'wget or curl not found, exiting..' >&2; return 1
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
  { [ "$#" -eq 0 ] && echo "$ps_out" || grep -i "$@" <<<"$ps_out"; } | head -n 11
  if [ ! -x "$(command -v pstree)" ]; then
    echo 'pstree not found (e.g. yum install -y psmisc).'
  else
    if [ "$#" -eq 0 ]; then
      pids=($(sed -n '2,4p' <<< "$ps_out" | awk '{print $2}'))
    else
      pids=($(grep -i "$@" <<< "$ps_out" | awk '{print $2}'))
    fi
    for pid in "${pids[@]}"; do
      pstree_out=$(pstree "$pstree_flags" "$pid")
      [[ $pstree_out =~ $pid ]] && head -n 8 <<< "$pstree_out" | grep --color -E "^|$pid"
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
  [ "$#" -gt 0 ] && ps_out=$(grep -i "$@" <<< "$ps_out" | head -n 16)
  head -n 16 <<< "$ps_out" | awk '{ hr=$2/1024 ; printf("%7s %9.2f Mb\t",$1,hr) } { for ( x=3 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'
}

sudorun() {
  if [ "$#" -eq 0 ]; then echo 'Need a command to run.'; return 1; fi
  local cmd=$1
  shift
  if [ ! -x "$(command -v "$cmd")" ] && type "$cmd" | grep -q "$cmd is a \(shell \)\?function"; then
    echo -e "Running as bash function..\n" >&2
    sudo bash -c "$(declare -f "$cmd"); $cmd $*"
    return 0
  fi
  case $cmd in
    v|vi|vim) sudo TERM=xterm-256color "$(/usr/bin/which vim)" -u "$HOME/.vim/config/mini.vim" "$@" ;;
    lf) EDITOR=vim XDG_CONFIG_HOME="$HOME/.config" sudo -E "$(/usr/bin/which lf)" -last-dir-path="$HOME/.vim/tmp/lf_dir" -command 'set previewer' -command 'map i $less -RiM "$f"' "$@" ;;
    *) TERM=xterm-256color EDITOR=vim XDG_CONFIG_HOME="$HOME/.config" sudo -E "$(/usr/bin/which "$cmd")" "$@" ;;
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
  for arg in "$@"; do
    if [ -f "$arg" ]; then
      case $arg in
        *.tar)                       tar xvf "$arg"     ;;
        *.tar.gz | *.tgz)            tar xvzf "$arg"    ;;
        *.tar.xz | *.xz)             tar xvJf "$arg"    ;;
        *.tar.bz2 | *.tbz | *.tbz2)  tar xvjf "$arg"    ;;
        *.bz2)                       bunzip2 "$arg"     ;;
        *.gz)                        gunzip "$arg"      ;;
        *.zip)                       unzip "$arg"       ;;
        *.rar)                       unrar x "$arg"     ;;
        *.Z)                         uncompress "$arg"  ;;
        *.7z)                        7z x "$arg"        ;;
        *)                           echo "Unable to extract '$arg'" ;;
      esac
    else
      tar czvf "$arg.tar.gz" "$arg"
    fi
  done
}

X() {  # extract to a directory / compress without top directory
  for arg in "$@"; do
    if [ -f "$arg" ]; then
      local dir="${arg%.*}"
      local filename="$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)_$arg"
      command mkdir -pv "$dir"
      command mv -i "$arg" "$dir/$filename"
      (cd "$dir" > /dev/null && x "$filename")
      command mv -n "$dir/$filename" "$arg"
    else
      tar czvf "$arg.tar.gz" -C "$arg" .
    fi
  done
}

path() {
  if [ "$#" -eq 0 ]; then
    echo -e "${PATH//:/\\n}"
  else
    type -a "$@"
    declare -f "$@" || true
  fi
}

vx() {
  if [ "$#" -eq 0 ]; then echo -e "Usage: $0 <vim-commands>\nRun vim commands in pipe: echo foo | $0 '%s/foo/bar' 'put=execute(\\\"echo &tabstop\\\")'" >&2; return 1; fi
  ex -sn "${@/#/+}" +'%write! /dev/stdout | quit!' /dev/stdin
}

vf() {  # find files: vf; open files from pipe: fd | vf
  local IFS=$'\n'
  if [ ! -t 0 ] ; then
    $EDITOR "$@" -- $(cat)
  else
    local fzftemp=($(FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND $*" FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi))
    [ -n "$fzftemp" ] && $EDITOR -- "${fzftemp[@]}"
  fi
}

cdf() {
  local fzftemp
  fzftemp=$(FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --color=always --hidden --exclude=.git $*" fzf --ansi --bind='tab:down,btab:up' --bind="\`:unbind(\`)+reload(fd --strip-cwd-prefix --color=always --hidden --exclude=.git --no-ignore $* || true)") && {
    [ -d "$fzftemp" ] && cd "$fzftemp" || {
      [ -d "$(dirname "$fzftemp" 2> /dev/null)" ] && cd "$(dirname "$fzftemp")"
    }
  }
}

vrg() {
  if [ "$#" -eq 0 ]; then
    [[ ! $(fc -ln -1) =~ ^rg* ]] && echo 'Need a string to search for.' || eval "v$(fc -ln -1)"
    return 0
  fi
  if [[ " $* " = *' --fixed-strings '* ]] || [[ " $* " = *' -F '* ]]; then
    $EDITOR -q <(rg "$@" --vimgrep) -c "/\V$1"  # use \V if rg is called with -F/--fixed-strings to search for string literal
  else
    $EDITOR -q <(rg "$@" --vimgrep) -c "/$1"
  fi
}

# https://github.com/junegunn/fzf/blob/HEAD/ADVANCED.md#ripgrep-integration
fif() {  # find in file
  if [ "$#" -eq 0 ]; then echo 'Need a string to search for.'; return 1; fi
  rg --files-with-matches --no-messages "$@" | fzf --multi --preview-window=up:60% --preview="rg --pretty --context 5 --max-columns 0 -- $(printf "%q " "$@"){+}" --bind="enter:execute($EDITOR -c \"/$1\" -- {+} < /dev/tty)"
}
rf() {  # livegrep: rf [pattern] [flags], pattern must be before flags, <C-s> to switch to fzf filter
  [ "$#" -gt 0 ] && [[ "$1" != -* ]] && local init_query="$1" && shift 1
  local rg_prefix="rg --column --line-number --no-heading --color=always$([ "$#" -gt 0 ] && printf " %q" "$@")"
  FZF_DEFAULT_COMMAND="$rg_prefix $(printf %q "${init_query:-}")" \
  fzf --ansi --layout=default --height=100% --disabled --query="${init_query:-}" \
      --header='╱ <C-s> (fzf mode) ╱ <C-r> (reset ripgrep) ╱' \
      --bind='ctrl-s:unbind(change,ctrl-s)+change-prompt(2. fzf> )+enable-search+clear-query+rebind(ctrl-r)' \
      --bind="ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($rg_prefix {q} || true)+rebind(change,ctrl-s)" \
      --bind="change:reload:sleep 0.2; $rg_prefix -- {q}" \
      --bind="enter:execute($EDITOR -c \"let @/={q}\" -c \"set hlsearch\" +{2} -- {1} < /dev/tty)" \
      --bind='tab:up,btab:down' \
      --prompt='1. ripgrep> ' --delimiter=: \
      --preview='bat --color=always --highlight-line {2} -- {1}' \
      --preview-window='up,40%,border-bottom,+{2}+3/3,~3'
}

unalias z 2> /dev/null
z() {
  local fzftemp
  if [ "$#" -eq 0 ]; then
    fzftemp=$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf --scheme=history --tac --header='Press ` to search under cwd' --bind='tab:down,btab:up' --bind="\`:unbind(\`)+reload(sort -n -k 3 -t '|' ~/.z | awk -F '|' -v cwd=\"$PWD\" '\$0~cwd {print \$1}')") && cd "$fzftemp"
  else
    _z 2>&1 "$@"
  fi
}

t() {  # create, restore, or switch tmux session
  local change current fzftemp sessions
  [ -n "$TMUX" ] && change='switch-client' && current=$(tmux display-message -p '#{session_name}') || change='attach-session'
  if [ "$#" -eq 0 ]; then
    fzftemp=$(tmux list-sessions -F '#{session_name}' 2> /dev/null | sed "/^$current$/d" | fzf --prompt='attach> ' --bind='tab:down,btab:up' --select-1 --exit-0) && tmux $change -t "$fzftemp"
    if [ "$?" -ne 0 ]; then
      sessions=$(ls ~/.local/share/tmux/resurrect/tmux_resurrect_*.txt 2> /dev/null)
      [ -n "$sessions" ] && fzftemp=$(echo "$sessions" | fzf --prompt='restore> ' --bind='ctrl-d:execute(mv {} {}.bak)' --bind='tab:down,btab:up' --tac --preview='cat {}') && {
        ln -sf "$fzftemp" ~/.local/share/tmux/resurrect/last
        tmux new-session -d " tmux run-shell $HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"
        tmux attach-session
      } || tmux
    fi
  else
    [ "$1" == a ] && tmux attach 2> /dev/null || tmux $change -t "$1" 2> /dev/null || (tmux new-session -d -s "$@" && tmux $change -t "$1")
  fi
}

man() {
  if [ "$#" -eq 0 ]; then
    local fzftemp
    fzftemp=$(man -k . 2> /dev/null | awk 'BEGIN {FS=OFS="- "} /\([1|4]\)/ {gsub(/\([0-9]\)/, "", $1); if (!seen[$0]++) { print }}' | fzf --bind='tab:down,btab:up' --prompt='man> ' --preview=$'echo {} | xargs -r man') && man "$(echo "$fzftemp" | awk -F' |,' '{print $1}')"
  elif [ "$EDITOR" = nvim ]; then
    MANPAGER='nvim +Man\!' command man "$@"
  else
    command man "$@"
  fi
}

findup() {
  if [ "$#" -ne 1 ]; then echo "Usage: $0 <file>" >&2; return 1; fi
  local dir=$PWD result
  while result=$(find "$dir" -maxdepth 1 -name "$@"); [ -z "$result" ] && [ "$dir" != "/" ]; do
    dir=$(dirname "$dir")
  done
  [ -z "$result" ] && return 1
  realpath -s --relative-to="$PWD" "$result"
}

envf() {
  local fzftemp
  fzftemp=$(printenv | cut -d= -f1 | fzf --bind='tab:down,btab:up' --query="${1:-}" --preview='printenv {}') && echo "$fzftemp=$(printenv "$fzftemp")"
}

jo() {  # basic implementation of https://github.com/jpmens/jo
  local args=()
  for arg in "$@"; do
    args+=(--arg "$(cut -d= -f1 <<< "$arg")" "$(cut -d= -f2- <<< "$arg")")
  done
  jq -n "${args[@]}" '$ARGS.named'
}

react() {
  if [ "$#" -lt 2 ]; then echo "Usage: $0 <dir_to_watch> <command>, use {} as placeholder of modified files." >&2; return 1; fi
  local changed
  echo "Watching \"$1\", passing modified files to \"${*:2}\" command every 2 seconds." >&2
  while true; do
    changed=($(fd --base-directory "$1" --absolute-path --type=f --changed-within 2s))
    if [ ${#changed[@]} -gt 0 ]; then
      local cmd="${@:2}"
      eval "${cmd//\{\}/${changed[@]}}"
    fi
    sleep 2
  done
}

untildone() {
  if [ "$#" -eq 0 ]; then
    echo -e "Usage: $0 <command>\n\t$0 wget -c <url>  # wget until complete\n\t$0 'git pull; sleep 3599; false'  # git pull every hour\n\t$0 '! ps <pid>'; ./run  # run after pid exits" >&2
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

set-env() {
  if [ "$#" -lt 1 ]; then echo "Usage: $0 {java_home|path}" >&2; return 1; fi
  local cmd reply
  while [ $# != 0 ]; do
    case $(tr '[:upper:]' '[:lower:]' <<< "$1") in
      java_home|javahome) cmd="export JAVA_HOME=\"$(asdf where java)\""; shift 1 ;;
      path) cmd="export PATH=\"$PWD:\$PATH\""; shift 1 ;;
      *) echo "Unsupported argument $1, exiting.." >&2; return 1 ;;
    esac
  done
  eval "$cmd"
  printf 'Write to .bashrc and .zshrc (y/N)? '
  read -r reply
  echo "$cmd" | if [[ "$reply" == [Yy] ]]; then tee -a ~/.bashrc ~/.zshrc && echo 'Appended to ~/.bashrc and ~/.zshrc'; else cat; fi
}

tldr() {
  curl "https://cheat.sh/${*// /+}"
}

getip() {
  if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [--private|ip|domain]" >&2
  elif [ "$#" -eq 0 ]; then
    curl -s "https://checkip.amazonaws.com"  # or ifconfig.me
  elif [ "$1" = '--private' ]; then  # en0: wireless, en1: ethernet, en3: thunderbolt to ethernet
    builtin command -v ifconfig > /dev/null 2>&1 && ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' || ipconfig getifaddr en0 2> /dev/null || ipconfig getifaddr en1 2> /dev/null || hostname -I 2> /dev/null || ip route get 1.1.1.1 | awk '{print $7}'
  elif [[ $1 =~ ^[0-9.]+$ ]]; then
    curl -s "http://ip-api.com/line/$1"
  else
    curl -s "https://dns.google.com/resolve?name=$1" | if builtin command -v python > /dev/null 2>&1; then python -m json.tool; else cat; fi
  fi
}

croc() {
  local line phrase
  if [ "$#" -eq 0 ]; then
    command croc
  elif grep -q '^[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<< "$1"; then
    command croc --curve p256 --yes "$@"
  elif [ -e "$1" ] || [ "$1" = send ]; then
    [ "$1" = send ] && shift 1
    timeout 60 croc send "$@" 2>&1 | {
      while read -r line; do
        echo "$line"
        [ -z "$phrase" ] && phrase=$(grep -o '[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<< "$line") && echo -n " command croc --curve p256 --yes $phrase" | y
      done
    }
  else
    command croc "$@"
  fi
}

bin-update() {
  local executable
  for executable in "$@"; do
    local bin="$HOME/.local/bin/$executable" vim_bin="$HOME/.vim/bin/$executable"
    if [ ! -x "$bin" ] || [ ! -x "$vim_bin" ]; then
      echo "$executable not found, skipping.." >&2; continue
    fi
    "$bin" --version || "$bin" -version || "$bin" -V || "$bin" version
    mkdir -p "$HOME/config-backup"
    command mv -v "$bin" "$HOME/config-backup/$executable.backup_$(date +%s)"
    "$vim_bin" --version || "$vim_bin" -version || "$vim_bin" -V || "$vim_bin" version
  done
}

docker-shell() {
  if [[ $1 != vim* ]]; then
    local selected_id=$(docker ps | grep -v IMAGE | awk '{printf "%s %-30s %s\n", $1, $2, $3}' | fzf --no-sort --tiebreak=begin,index --query="${1:-}")
    if [ -n "$selected_id" ]; then
      printf "\n → %s\n" "$selected_id"
      selected_id=$(awk '{print $1}' <<< "$selected_id")
      docker exec -it "$selected_id" /bin/sh -c 'eval $(grep ^$(id -un): /etc/passwd | cut -d : -f 7-)' || docker exec -it "$selected_id" sh
    fi
    return $?
  fi
  if ! docker image ls | grep -q ubuntu_vim; then
    docker build --network host -t ubuntu_vim -f ~/.vim/Dockerfile ~/.vim || return 1
    echo -e "\n\nFinished building image. To commit new change: docker commit vim_container ubuntu_vim"
  fi
  case $1 in
    vim-once) docker run --network host -it --name vim_container_temp --rm ubuntu_vim; return $? ;;
    vim-remove) docker container rm $(docker ps -aq --filter ancestor=ubuntu_vim) && docker image rm ubuntu_vim; return $? ;;
    vim-build) docker build --network host -t ubuntu_vim -f ~/.vim/Dockerfile ~/.vim; return $? ;;
    vim) local container_name=${2:-vim_container} ;;
    *) echo -e "Usage: $0 {vim-once|vim-remove|vim-build|vim [container-name]}\nReceived argument $1, exiting.." >&2; return 1 ;;
  esac
  local running=$(docker inspect -f '{{.State.Running}}' "$container_name" 2> /dev/null)
  if [ "$running" == true ]; then
    echo 'Starting shell in running container..'; docker exec -it "$container_name" zsh
  elif [ "$running" == false ]; then
    echo 'Starting stopped container..'; docker start -ai "$container_name"
  else
    echo "Starting new container ($container_name) with host network and docker socket mapped.."
    mkdir -p "$HOME/.local/docker-share"
    docker run --network host -v /var/run/docker.sock:/var/run/docker.sock -v "$HOME/.local/docker-share":/docker-share -it --name "$container_name" ubuntu_vim
  fi
}

ec2() {
  local instances ids curr_state
  case $1 in
    start) curr_state=stopped ;;
    stop) curr_state=running ;;
    refresh)
      aws ec2 describe-instances --filter 'Name=tag-key,Values=Name' 'Name=tag-value,Values=*' 'Name=instance-state-name,Values=running' --query "Reservations[*].Instances[*][NetworkInterfaces[0].Association.PublicDnsName,Tags[?Key=='Name'].Value[] | [0]]" --output text
      return 0 ;;
    ssh)
      local tag=${2:-$(aws ec2 describe-instances --filter 'Name=tag-key,Values=Name' 'Name=tag-value,Values=*' "Name=instance-state-name,Values=*" --query "Reservations[*].Instances[*][Tags[?Key=='Name'].Value[] | [0],InstanceId]" --output text | fzf | awk '{print $1}')}
      [ -z "$tag" ] && return 1
      local host=$(aws ec2 describe-instances --filter 'Name=tag-key,Values=Name' 'Name=tag-value,Values=*' 'Name=instance-state-name,Values=running' --query "Reservations[*].Instances[*][NetworkInterfaces[0].Association.PublicDnsName,Tags[?Key=='Name'].Value[] | [0]]" --output text | grep "\s$tag$" | awk '{print $1}')
      local config="Host $tag\n  HostName $host\n  User %s\n  IdentityFile ~/.ssh/ec2.pem\n\n"
      if [ -z "$host" ]; then
        ec2 start "$tag" && sleep 17 && ec2 ssh "$tag"
        return $?
      fi
      echo "ssh to ec2: $host" >&2
      shift 2
      sed -i "/Host $tag/,/^\s*\$/{d}" ~/.ssh/ec2hosts 2> /dev/null
      printf "$config" ubuntu >> ~/.ssh/ec2hosts
      local start=$SECONDS
      ssh -o 'StrictHostKeyChecking no' -i ~/.ssh/ec2.pem "$@" "ubuntu@$host" || {
        if [ $((($SECONDS - $start))) -lt 10 ]; then
          sed -i "/Host $tag/,/^\s*\$/{d}" ~/.ssh/ec2hosts 2> /dev/null
          printf "$config" ec2-user >> ~/.ssh/ec2hosts
          ssh -o 'StrictHostKeyChecking no' -i ~/.ssh/ec2.pem "$@" "ec2-user@$host"
        fi
      }
      return 0 ;;
    *) echo "Usage: $0 {start|stop|refresh|ssh} [instance-tag] [options]" >&2; return 1 ;;
  esac
  instances=$(aws ec2 describe-instances --filter 'Name=tag-key,Values=Name' 'Name=tag-value,Values=*' "Name=instance-state-name,Values=$curr_state" --query "Reservations[*].Instances[*][Tags[?Key=='Name'].Value[] | [0],InstanceId]" --output text)
  if [ -n "$2" ]; then
    ids=$(echo "$instances" | grep "^$2\s" | awk '{print $2}')
  else
    ids=$(echo "$instances" | fzf --multi | awk '{print $2}')
  fi
  [ -z "$ids" ] && return 1
  if [ "$curr_state" = stopped ]; then
    aws ec2 start-instances --instance-ids $(echo $ids)
  else
    aws ec2 stop-instances --instance-ids $(echo $ids)
  fi
}

os-get() {
  ver() {
    awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }' <<<"$*"
  }
  if [ "$#" -eq 0 ]; then echo "Usage: $0 <3-digit-version> [query]" >&2; return 1; fi
  local version=$1 arch=$([[ $(uname -m) =~ (x86_64|amd64) ]] && echo x64 || echo arm64) url selected
  local core=('opensearch' 'opensearch-dashboards') es=('elasticsearch' 'kibana') opensearch_plugin=('opensearch-security' 'opensearch-sql' 'opensearch-reports-scheduler' 'opensearch-observability' 'opensearch-job-scheduler' 'opensearch-alerting' 'opensearch-anomaly-detection' 'opensearch-ml' 'opensearch-notifications' 'opensearch-notifications-core' 'opensearch-index-management')
  local artifacts=("${core[@]}" "${opensearch_plugin[@]}" "${es[@]}")
  selected=$(printf "%s\n" "${artifacts[@]}" | fzf --query="$2" --select-1 --bind='tab:down,btab:up') || return 1
  if printf '%s\0' "${es[@]}" | grep -q -x -z -F -- "$selected"; then
    [ "$arch" = 'x64' ] && arch=x86_64 || arch=aarch64
    url="https://artifacts.elastic.co/downloads/$selected/$selected-oss-$version-linux-$arch.tar.gz"
  elif printf '%s\0' "${core[@]}" | grep -q -x -z -F -- "$selected"; then
    if [ "$(ver "$version")" -gt "$(ver "$(curl -fsSL https://opensearch.org/ | rg -o 'Current Version: ([\d\.]+)' -r '$1')")" ]; then
      url="https://ci.opensearch.org/ci/dbc/distribution-build-$selected/$version/latest/linux/$arch/tar/dist/$selected/$selected-$version-linux-$arch.tar.gz"
      printf "\033[0;36m%s\033[0m\n" "Manifest: https://ci.opensearch.org/ci/dbc/distribution-build-$selected/$version/latest/linux/$arch/tar/dist/$selected/manifest.yml" >&2
    else
      url="https://artifacts.opensearch.org/releases/bundle/$selected/$version/$selected-$version-linux-$arch.tar.gz"
    fi
  elif printf '%s\0' "${opensearch_plugin[@]}" | grep -q -x -z -F -- "$selected"; then
    if [ "$(ver "$version")" -ge "$(ver '1.3.2')" ]; then  # url changed after 1.3.2
      url="https://ci.opensearch.org/ci/dbc/distribution-build-opensearch/$version/latest/linux/$arch/tar/builds/opensearch/plugins/$selected-$version.0.zip"
    else
      url="https://ci.opensearch.org/ci/dbc/distribution-build-opensearch/$version/latest/linux/$arch/builds/opensearch/plugins/$selected-$version.0.zip"
    fi
  fi
  printf "\033[0;36m%s\033[0m\n" "Downloading from: $url" >&2
  wget "$url"
}

theme() {  # locally toggles wezterm theme, remotely updates configs to match terminal theme
  if [ -n "$WEZTERM_EXECUTABLE" ]; then
    grep -q 'local light_theme = false' ~/.vim/config/wezterm.lua && export LIGHT_THEME=1 || export LIGHT_THEME=0
    sed -i "s/\(local light_theme = \)\(true\|false\)/\1$([ "$LIGHT_THEME" = 1 ] && echo 'true' || echo 'false')/" ~/.vim/config/wezterm.lua
  else
    sed -i "s/LIGHT_THEME:-[0-9]/LIGHT_THEME:-$(bash -c "[ -n \"\$TMUX\" ] && read -rs -d \\\\ -p \$'\\033Ptmux;\\033\\e]11;?\\e\\\\\\033\\\\' osc11 || read -rs -d \\\\ -p \$'\\e]11;?\\e\\\\' osc11 && printf %q \"\$osc11\" | awk '{match(\$0, /rgb:([0-9a-f]+)\\/([0-9a-f]+)\\/([0-9a-f]+)/, arr); if (strtonum(\"0x\"arr[1]) > 32639 && strtonum(\"0x\"arr[2]) > 32639 && strtonum(\"0x\"arr[3]) > 32639) print \"1\"; else print \"0\"}'")/" ~/.vim/config/colors.sh
    unset LIGHT_THEME
  fi
  source ~/.vim/config/common.sh
  if [ -n "$TMUX" ]; then tmux set-environment -ug LIGHT_THEME; fi
}

.vim-disable-binary-downloads() {
  export PATH="${PATH//.vim\/bin/.vim/local-bin}"
  export FZF_DEFAULT_COMMAND="command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune -o -type f -print -o -type d -print -o -type l -print 2> /dev/null | cut -b3-"
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
}

[ -n "$DOT_VIM_LOCAL_BIN" ] && .vim-disable-binary-downloads

# ====================== MacOS ==========================
if [[ $OSTYPE = darwin* ]]; then
  alias idea='open -na "IntelliJ IDEA.app" --args'
  alias ideace='open -na "IntelliJ IDEA CE.app" --args'
  alias refresh-icon-cache='rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock'
  alias toggle-dark-theme='automator ~/.vim/config/macToggleDark.wflow'
  browser-history() {
    local cols=$((COLUMNS / 3)) sep='{::}' fzftemp fzfprompt
    if [ -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" ]; then
      fzfprompt='Edge> '
      command cp -f "$HOME/Library/Application Support/Microsoft Edge/Default/History" /tmp/browser-history-fzf-temp
    elif [ -f "$HOME/Library/Application Support/Google/Chrome/Default/History" ]; then
      fzfprompt='Chrome> '
      command cp -f "$HOME/Library/Application Support/Google/Chrome/Default/History" /tmp/browser-history-fzf-temp
    else
      echo "Chrome and Edge histories not found, exiting.."
      return 1
    fi
    fzftemp=$(sqlite3 -separator $sep /tmp/browser-history-fzf-temp "select substr(title, 1, $cols), url from urls order by last_visit_time desc" |
      awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
      fzf --tiebreak=index --toggle-sort=\` --header='Press ` to toggle sort' --prompt="$fzfprompt" --ansi --multi) && \
      echo $fzftemp | sed 's#.*\(https*://\)#\1#' | xargs open
  }
fi
