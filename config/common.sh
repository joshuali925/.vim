source ~/.vim/config/z.sh
source ~/.vim/config/lf_icons.sh

export PATH=$HOME/.local/bin:$PATH:$HOME/.vim/bin
export EDITOR='vim'
export LS_COLORS=$(cat ~/.vim/config/.dircolors)
export PYTHONSTARTUP=~/.vim/config/.pythonrc
export RIPGREP_CONFIG_PATH=~/.vim/config/.ripgreprc
export FZF_DEFAULT_OPTS='--layout=reverse --height 40%'
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files'
export FZF_ALT_C_COMMAND="rg --files --null | xargs -0 dirname | awk '!h[\$0]++'"
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range :50 {}'

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
alias mkdir='mkdir -p'
alias ll='ls -AlhF --color=auto'
alias la='ls -AF --color=auto'
alias ls='ls -CF --color=auto'
alias l='ls -CF --color=auto'
alias size='du -h --max-depth=1 | sort -hr'
alias path='echo -e ${PATH//:/\\n}'
alias file_permission='stat --printf "%a %n \n"'
alias v='vim'
alias vp='vim $($(fc -ln -1))'
alias vi='vim'
alias vimm='vim ~/.vim/vimrc'
alias gacp='git add -A && git commit -m "update" && git push origin master'
alias venv='source venv/bin/activate'
alias bpy='env PYTHONSTARTUP= bpython'
alias service='sudo service'
alias apt='sudo apt'
alias lg='lazygit'
alias lf='lf -last-dir-path="$HOME/.cache/lf_dir"'
alias fl='lf -last-dir-path="$HOME/.cache/lf_dir" && cd "$(cat "$HOME/.cache/lf_dir")"'
alias 0='[ -f "$HOME/.cache/lf_dir" ] && cd "$(cat "$HOME/.cache/lf_dir")"'
alias rgf="rg --files | rg"
alias rgd="rg --files --null | xargs -0 dirname | sort -u | rg"

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
alias gds='git diff --stat'
alias gdst='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpnp='git pull origin master && git push origin master'
alias ggpull='git pull origin master'
alias ggl='git pull origin master'
alias ggpur='git pull --rebase origin master'
alias glum='git pull upstream master'
alias ggpush='git push origin master'
alias ggp='git push origin master'
alias ggsup='git branch --set-upstream-to=origin/master'
alias gpsup='git push --set-upstream origin master'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^:lower:"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='gitk --all --branches'
alias gl='git pull'
alias glg='git log --stat --max-count=10'
alias glgg='git log --graph --max-count=10'
alias glgga='git log --graph --decorate --all'
alias glo='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
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
alias grl='git reflog --date=format:%T --pretty=format:"%C(yellow)%h%Creset %C(037)%gD:%Creset %C(white)%gs%Creset%C(auto)%d%Creset"'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grup='git remote update'
alias grv='git remote -v'
alias gs='git status'
alias gsd='git svn dcommit'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -sb'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gts='git tag -s'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "--wip--" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gvt='git verify-tag'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
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

printcolor() {
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

vf() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(rg --files | fzf) && vim "$FZFTEMP"
  else
    FZFTEMP=$(rg --files | rg "$*" | fzf) && vim "$FZFTEMP"
  fi
}

cdf() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(rg --files | fzf) && cd "$(dirname $FZFTEMP)"
  else
    FZFTEMP=$(rg --files | rg "$*" | fzf) && cd "$(dirname $FZFTEMP)"
  fi
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  local FZFTEMP
  FZFTEMP="$(rg --files-with-matches --no-messages "$1" | fzf --preview "bat --style=plain --color=always {} | rg --colors 'match:bg:yellow' --pretty --context 5 '$1' || rg --pretty --context 5 '$1' {}")" && vim "$FZFTEMP" -c "silent execute '/$1'"
}

unalias z 2> /dev/null
z() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(_z -l 2>&1 | fzf --tac) && cd "$(echo $FZFTEMP | sed 's/^[0-9,.]* *//')"
  else
    _z 2>&1 "$*"
  fi
}
zc() {
  local FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=$(_z -c -l 2>&1 | fzf --tac) && cd "$(echo $FZFTEMP | sed 's/^[0-9,.]* *//')"
  else
    _z 2>&1 -c "$*"
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
