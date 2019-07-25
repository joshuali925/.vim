# RUN ONCE AT SETUP
# set -Ux PYTHONSTARTUP $HOME/.vim/others/.pythonrc
# set Z_DATA $HOME/.local/share/z/data
# set Z_DATA_DIR $HOME/.local/share/z
# set Z_EXCLUDE $HOME

# install extensions, should be installed already
# fisher add jethrokuan/z rafaelrinaldi/pure

# cd triggers ls
function echo_dir --on-variable PWD; ls -CF; end;

# add path
set -gx PATH $HOME/.local/bin $HOME/.vim/bin $HOME/miniconda3/bin $PATH
source /home/kite/miniconda3/etc/fish/conf.d/conda.fish
# abbr -a condabase 'source /home/kite/miniconda3/etc/fish/conf.d/conda.fish'

# already added to fish_variables
# abbr -a mkdir 'mkdir -p'
# abbr -a ll 'ls -AlhF'
# abbr -a la 'ls -AF'
# abbr -a l 'ls -CF'
# abbr -a size 'du -h --max-depth=1 | sort -hr'
# abbr -a vi 'vim'
# abbr -a vimm 'vim ~/.vimrc'
# abbr -a vims 'vim -c "source ~/.cache/vim/session.vim"'
# abbr -a bpython 'bpython -i'
# abbr -a gacp 'git add -A && git commit -m "update" && git push origin master'
# abbr -a venv 'source venv/bin/activate.fish'
# abbr -a service 'sudo service'
# abbr -a apt 'sudo apt'
# abbr -a which 'type -a'
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
# abbr -a glg 'git log --stat --max-count = 10'
# abbr -a glgg 'git log --graph --max-count = 10'
# abbr -a glgga 'git log --graph --decorate --all'
# abbr -a glo 'git log --oneline --decorate --color'
# abbr -a glog 'git log --oneline --decorate --color --graph'
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
# abbr -a gwch 'git whatchanged -p --abbrev-commit --pretty = medium'
# abbr -a gwip 'git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'


# fix color
for color_variable in (set -n | grep -e pure_color_)
    set --erase $color_variable
end
set --global pure_color_primary (set_color cyan)
source ~/.config/fish/conf.d/pure.fish
set -x LS_COLORS "no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:*.tar=00;38;5;61:*.tgz=00;38;5;61:*.arj=00;38;5;61:*.taz=00;38;5;61:*.lzh=00;38;5;61:*.lzma=00;38;5;61:*.tlz=00;38;5;61:*.txz=00;38;5;61:*.zip=00;38;5;61:*.z=00;38;5;61:*.Z=00;38;5;61:*.dz=00;38;5;61:*.gz=00;38;5;61:*.lz=00;38;5;61:*.xz=00;38;5;61:*.bz2=00;38;5;61:*.bz=00;38;5;61:*.tbz=00;38;5;61:*.tbz2=00;38;5;61:*.tz=00;38;5;61:*.deb=00;38;5;61:*.rpm=00;38;5;61:*.jar=00;38;5;61:*.rar=00;38;5;61:*.ace=00;38;5;61:*.zoo=00;38;5;61:*.cpio=00;38;5;61:*.7z=00;38;5;61:*.rz=00;38;5;61:*.apk=00;38;5;61:*.gem=00;38;5;61:*.jpg=00;38;5;136:*.JPG=00;38;5;136:*.jpeg=00;38;5;136:*.gif=00;38;5;136:*.bmp=00;38;5;136:*.pbm=00;38;5;136:*.pgm=00;38;5;136:*.ppm=00;38;5;136:*.tga=00;38;5;136:*.xbm=00;38;5;136:*.xpm=00;38;5;136:*.tif=00;38;5;136:*.tiff=00;38;5;136:*.png=00;38;5;136:*.PNG=00;38;5;136:*.svg=00;38;5;136:*.svgz=00;38;5;136:*.mng=00;38;5;136:*.pcx=00;38;5;136:*.dl=00;38;5;136:*.xcf=00;38;5;136:*.xwd=00;38;5;136:*.yuv=00;38;5;136:*.cgm=00;38;5;136:*.emf=00;38;5;136:*.eps=00;38;5;136:*.CR2=00;38;5;136:*.ico=00;38;5;136:*.tex=00;38;5;245:*.rdf=00;38;5;245:*.owl=00;38;5;245:*.n3=00;38;5;245:*.ttl=00;38;5;245:*.nt=00;38;5;245:*.torrent=00;38;5;245:*.xml=00;38;5;245:*Makefile=00;38;5;245:*Rakefile=00;38;5;245:*Dockerfile=00;38;5;245:*build.xml=00;38;5;245:*rc=00;38;5;245:*1=00;38;5;245:*.nfo=00;38;5;245:*README=00;38;5;245:*README.txt=00;38;5;245:*readme.txt=00;38;5;245:*.md=00;38;5;245:*README.markdown=00;38;5;245:*.ini=00;38;5;245:*.yml=00;38;5;245:*.cfg=00;38;5;245:*.conf=00;38;5;245:*.h=00;38;5;245:*.hpp=00;38;5;245:*.c=00;38;5;245:*.cpp=00;38;5;245:*.cxx=00;38;5;245:*.cc=00;38;5;245:*.objc=00;38;5;245:*.sqlite=00;38;5;245:*.go=00;38;5;245:*.sql=00;38;5;245:*.csv=00;38;5;245:*.log=00;38;5;240:*.bak=00;38;5;240:*.aux=00;38;5;240:*.lof=00;38;5;240:*.lol=00;38;5;240:*.lot=00;38;5;240:*.out=00;38;5;240:*.toc=00;38;5;240:*.bbl=00;38;5;240:*.blg=00;38;5;240:*~=00;38;5;240:*#=00;38;5;240:*.part=00;38;5;240:*.incomplete=00;38;5;240:*.swp=00;38;5;240:*.tmp=00;38;5;240:*.temp=00;38;5;240:*.o=00;38;5;240:*.pyc=00;38;5;240:*.class=00;38;5;240:*.cache=00;38;5;240:*.aac=00;38;5;166:*.au=00;38;5;166:*.flac=00;38;5;166:*.mid=00;38;5;166:*.midi=00;38;5;166:*.mka=00;38;5;166:*.mp3=00;38;5;166:*.mpc=00;38;5;166:*.ogg=00;38;5;166:*.opus=00;38;5;166:*.ra=00;38;5;166:*.wav=00;38;5;166:*.m4a=00;38;5;166:*.axa=00;38;5;166:*.oga=00;38;5;166:*.spx=00;38;5;166:*.xspf=00;38;5;166:*.mov=00;38;5;166:*.MOV=00;38;5;166:*.mpg=00;38;5;166:*.mpeg=00;38;5;166:*.m2v=00;38;5;166:*.mkv=00;38;5;166:*.ogm=00;38;5;166:*.mp4=00;38;5;166:*.m4v=00;38;5;166:*.mp4v=00;38;5;166:*.vob=00;38;5;166:*.qt=00;38;5;166:*.nuv=00;38;5;166:*.wmv=00;38;5;166:*.asf=00;38;5;166:*.rm=00;38;5;166:*.rmvb=00;38;5;166:*.flc=00;38;5;166:*.avi=00;38;5;166:*.fli=00;38;5;166:*.flv=00;38;5;166:*.gl=00;38;5;166:*.m2ts=00;38;5;166:*.divx=00;38;5;166:*.webm=00;38;5;166:*.axv=00;38;5;166:*.anx=00;38;5;166:*.ogv=00;38;5;166:*.ogx=00;38;5;166:"
