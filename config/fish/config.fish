# RUN ONCE AT SETUP
# set -Ux PYTHONSTARTUP $HOME/.vim/config/.pythonrc
# set Z_DATA $HOME/.local/share/z/data
# set Z_DATA_DIR $HOME/.local/share/z
# set Z_EXCLUDE $HOME

# install extensions, should be installed already
# fisher add jethrokuan/z rafaelrinaldi/pure

# cd triggers ls
function echo_dir --on-variable PWD; ls -CF; end;

function f
    find . -iname \*$argv[1]\*
end
function cc
    gcc $argv[1].c -o $argv[1] -g && ./$argv
end

# add path
set -gx PATH $HOME/.local/bin $HOME/.vim/bin $PATH
# set -gx PATH $HOME/.local/bin $HOME/.vim/bin $HOME/miniconda3/bin $PATH
# source /home/kite/miniconda3/etc/fish/conf.d/conda.fish
# abbr -a condabase 'source /home/kite/miniconda3/etc/fish/conf.d/conda.fish'

# already added to fish_variables
# abbr -a mkdir 'mkdir -p'
# abbr -a ll 'ls -AlhF'
# abbr -a la 'ls -AF'
# abbr -a l 'ls -CF'
# abbr -a size 'du -h --max-depth=1 | sort -hr'
# abbr -a v 'vim'
# abbr -a vi 'vim'
# abbr -a vf 'vim (fd --hidden --exclude ".git" | fzf --height 40%)'
# abbr -a vimm 'vim ~/.vim/vimrc'
# abbr -a vims 'vim -c "source ~/.cache/vim/session.vim"'
# abbr -a gacp 'git add -A && git commit -m "update" && git push origin master'
# abbr -a venv 'source venv/bin/activate.fish'
# abbr -a service 'sudo service'
# abbr -a apt 'sudo apt'
# abbr -a which 'type -a'
# abbr -a cdf 'cd (fd --hidden --exclude ".git" --type="directory" | fzf --height 40%) && pwd'
# abbr -a zf 'cd (z --list | awk "{print \$2}" | fzf --height 40%) && pwd'
# abbr -a - 'cd -'
# abbr -a ... 'cd ../..'

# abbr -a g 'git'
# abbr -a ga 'git add'
# abbr -a gau 'git add -u'
# abbr -a gaa 'git add --all'
# abbr -a gapa 'git add --patch'
# abbr -a gb 'git branch'
# abbr -a gba 'git branch -a'
# abbr -a gbd 'git branch -d'
# abbr -a gbl 'git blame -b -w'
# abbr -a gbnm 'git branch --no-merged'
# abbr -a gbr 'git branch --remote'
# abbr -a gbs 'git bisect'
# abbr -a gbsb 'git bisect bad'
# abbr -a gbsg 'git bisect good'
# abbr -a gbsr 'git bisect reset'
# abbr -a gbss 'git bisect start'
# abbr -a gc 'git commit -v'
# abbr -a gc! 'git commit -v --amend'
# abbr -a gca 'git commit -v -a'
# abbr -a gca! 'git commit -v -a --amend'
# abbr -a gcan! 'git commit -v -a --no-edit --amend'
# abbr -a gcans! 'git commit -v -a -s --no-edit --amend'
# abbr -a gcam 'git commit -a -m'
# abbr -a gcsm 'git commit -s -m'
# abbr -a gcb 'git checkout -b'
# abbr -a gcf 'git config --list'
# abbr -a gcl 'git clone --recursive'
# abbr -a gclean 'git clean -fd'
# abbr -a gpristine 'git reset --hard && git clean -dfx'
# abbr -a gcm 'git checkout master'
# abbr -a gcd 'git checkout develop'
# abbr -a gcmsg 'git commit -m'
# abbr -a gco 'git checkout'
# abbr -a gcount 'git shortlog -sn'
# abbr -a gcp 'git cherry-pick'
# abbr -a gcpa 'git cherry-pick --abort'
# abbr -a gcpc 'git cherry-pick --continue'
# abbr -a gcs 'git commit -S'
# abbr -a gd 'git diff'
# abbr -a gdca 'git diff --cached'
# abbr -a gdct 'git describe --tags `git rev-list --tags --max-count=1`'
# abbr -a gdt 'git diff-tree --no-commit-id --name-only -r'
# abbr -a gdw 'git diff --word-diff'
# abbr -a gf 'git fetch'
# abbr -a gfa 'git fetch --all --prune'
# abbr -a gfo 'git fetch origin'
# abbr -a gg 'git gui citool'
# abbr -a gga 'git gui citool --amend'
# abbr -a ggpnp 'git pull origin master && git push origin master'
# abbr -a ggpull 'git pull origin master'
# abbr -a ggl 'git pull origin master'
# abbr -a ggpur 'git pull --rebase origin master'
# abbr -a glum 'git pull upstream master'
# abbr -a ggpush 'git push origin master'
# abbr -a ggp 'git push origin master'
# abbr -a ggfl 'git push --force-with-lease origin <your_argument>/master'
# abbr -a ggsup 'git branch --set-upstream-to=origin/master'
# abbr -a gpsup 'git push --set-upstream origin master'
# abbr -a gignore 'git update-index --assume-unchanged'
# abbr -a gignored 'git ls-files -v | grep "^:lower:"'
# abbr -a git-svn-dcommit-push 'git svn dcommit && git push github master:svntrunk'
# abbr -a gk 'gitk --all --branches'
# abbr -a gl 'git pull'
# abbr -a glg 'git log --stat --max-count=10'
# abbr -a glgg 'git log --graph --max-count=10'
# abbr -a glgga 'git log --graph --decorate --all'
# abbr -a glo 'git log --oneline --decorate --color'
# abbr -a glog 'git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
# abbr -a glp '_git_log_prettily (git log --pretty=$1)'
# abbr -a gm 'git merge'
# abbr -a gma 'git merge --abort'
# abbr -a gmt 'git mergetool --no-prompt'
# abbr -a gp 'git push'
# abbr -a gpoat 'git push origin --all && git push origin --tags'
# abbr -a gr 'git remote'
# abbr -a grb 'git rebase'
# abbr -a grba 'git rebase --abort'
# abbr -a grbc 'git rebase --continue'
# abbr -a grbd 'git rebase develop'
# abbr -a grbm 'git rebase master'
# abbr -a grbs 'git rebase --skip'
# abbr -a grbi 'git rebase -i'
# abbr -a grh 'git reset HEAD'
# abbr -a grhh 'git reset HEAD --hard'
# abbr -a grmv 'git remote rename'
# abbr -a grrm 'git remote remove'
# abbr -a grset 'git remote set-url'
# abbr -a grup 'git remote update'
# abbr -a grv 'git remote -v'
# abbr -a gsd 'git svn dcommit'
# abbr -a gsps 'git show --pretty = short --show-signature'
# abbr -a gsr 'git svn rebase'
# abbr -a gss 'git status -s'
# abbr -a gst 'git status'
# abbr -a gsta 'git stash save'
# abbr -a gstaa 'git stash apply'
# abbr -a gstd 'git stash drop'
# abbr -a gstl 'git stash list'
# abbr -a gstp 'git stash pop'
# abbr -a gsts 'git stash show --text'
# abbr -a gsu 'git submodule update'
# abbr -a gts 'git tag -s'
# abbr -a gunignore 'git update-index --no-assume-unchanged'
# abbr -a gunwip 'git log -n 1 | grep -q -c "--wip--" && git reset HEAD~1'
# abbr -a gup 'git pull --rebase'
# abbr -a gvt 'git verify-tag'
# abbr -a gwch 'git whatchanged -p --abbrev-commit --pretty=medium'
# abbr -a gwip 'git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'

# git diff-so-fancy
function gdf
    git diff $argv | diff-so-fancy | less --tabs=4 -RFX
end


# lfcd
function fl
    set tmp (mktemp)
    lf -last-dir-path=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end

# fix color
for color_variable in (set -n | grep -e pure_color_)
    set --erase $color_variable
end
set --global pure_color_primary (set_color cyan)
source ~/.config/fish/conf.d/pure.fish
set -x LS_COLORS (cat ~/.vim/config/.dircolors)
