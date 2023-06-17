export LIGHT_THEME="${LIGHT_THEME:-0}"

# to update with dircolors, run: r !dircolors ~/.vim/config/dircolors
export LS_COLORS='no=01;30:rs=0:fi=00;00:di=01;34:ow=01;04;34:st=00;37;44:tw=04;37;44:ln=01;35:mh=04;36:pi=01;30;43:so=01;30;43:do=01;30;43:bd=04;33;40:cd=04;33;40:or=00;31;40:mi=01;31;40:ex=04;32:su=00;30;41:sg=00;30;43:ca=01;30;41:*.7z=01;33:*.Z=01;33:*.ace=01;33:*.alz=01;33:*.apk=01;33:*.arc=01;33:*.arj=01;33:*.bz=01;33:*.bz2=01;33:*.cab=01;33:*.cpio=01;33:*.deb=01;33:*.dmg=01;33:*.dz=01;33:*.ear=01;33:*.gz=01;33:*.iso=01;33:*.jar=01;33:*.lha=01;33:*.lrz=01;33:*.lz=01;33:*.lz4=01;33:*.lzh=01;33:*.lzma=01;33:*.lzo=01;33:*.rar=01;33:*.rpm=01;33:*.rz=01;33:*.sar=01;33:*.t7z=01;33:*.tar=01;33:*.taz=01;33:*.tbz=01;33:*.tbz2=01;33:*.tgz=01;33:*.tlz=01;33:*.txz=01;33:*.tz=01;33:*.tzo=01;33:*.tzst=01;33:*.war=01;33:*.xz=01;33:*.z=01;33:*.zip=01;33:*.zoo=01;33:*.zst=01;33:*#=01;30:*dump=01;30:*history=01;30:*hst=01;30:*hsts=01;30:*ignore=01;30:*~=01;30:*.BAK=01;30:*.LOG=01;30:*.OLD=01;30:*.ORIG=01;30:*.bak=01;30:*.cache=01;30:*.class=01;30:*.log=01;30:*.o=01;30:*.old=01;30:*.orig=01;30:*.out=01;30:*.part=01;30:*.pyc=01;30:*.swo=01;30:*.swp=01;30:*.temp=01;30:*.tmp=01;30:*Dockerfile=00;32:*Makefile=00;32:*Rakefile=00;32:*config=00;32:*profile=00;32:*rc=00;32:*.cfg=00;32:*.conf=00;32:*.ini=00;32:*.toml=00;32:*.xml=00;32:*.yml=00;32:*.yaml=00;32:*README=01;31:*README.txt=01;31:*readme.txt=01;31:*.MARKDOWN=01;31:*.MD=01;31:*.markdown=01;31:*.md=01;31:*.rst=01;31:*.doc=00;32:*.docx=00;32:*.dot=00;32:*.odg=00;32:*.odp=00;32:*.ods=00;32:*.odt=00;32:*.otg=00;32:*.otp=00;32:*.ots=00;32:*.ott=00;32:*.pdf=00;32:*.ppt=00;32:*.pptx=00;32:*.xls=00;32:*.xlsx=00;32:*.aac=00;36:*.au=00;36:*.axa=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.oga=00;36:*.ogg=00;36:*.ra=00;36:*.spx=00;36:*.wav=00;36:*.xspf=00;36:*.ai=00;36:*.bmp=00;36:*.cgm=00;36:*.dl=00;36:*.dvi=00;36:*.emf=00;36:*.eps=00;36:*.gif=00;36:*.jpeg=00;36:*.jpg=00;36:*.JPG=00;36:*.mng=00;36:*.pbm=00;36:*.pcx=00;36:*.pgm=00;36:*.png=00;36:*.PNG=00;36:*.ppm=00;36:*.pps=00;36:*.ppsx=00;36:*.ps=00;36:*.psd=00;36:*.svg=00;36:*.svgz=00;36:*.tga=00;36:*.tif=00;36:*.tiff=00;36:*.xbm=00;36:*.xcf=00;36:*.xpm=00;36:*.xwd=00;36:*.yuv=00;36:*.anx=00;36:*.asf=00;36:*.avi=00;36:*.axv=00;36:*.flc=00;36:*.fli=00;36:*.flv=00;36:*.gl=00;36:*.m2v=00;36:*.m4v=00;36:*.mkv=00;36:*.mov=00;36:*.MOV=00;36:*.mp4=00;36:*.mp4v=00;36:*.mpeg=00;36:*.mpg=00;36:*.nuv=00;36:*.ogm=00;36:*.ogv=00;36:*.ogx=00;36:*.qt=00;36:*.rm=00;36:*.rmvb=00;36:*.swf=00;36:*.vob=00;36:*.webm=00;36:*.wmv=00;36:*.torrent=00;32:';
# to use dircolors file directly, run: eval $(dircolors ~/.vim/config/dircolors)

export LF_ICONS='tw=:st=:ow=:dt=:di=:fi=:ln=:or=:ex=:*.7z=:*.a=:*.ai=:*.apk=:*.asm=:*.asp=:*.aup=:*.avi=:*.bat=:*.bmp=:*.bz2=:*.c=:*.c++=:*.cab=:*.cbr=:*.cbz=:*.cc=:*.class=:*.clj=:*.cljc=:*.cljs=:*.cmake=:*.coffee=:*.conf=:*.cp=:*.cpio=:*.cpp=:*.cs=:*.css=:*.cue=:*.cvs=:*.cxx=:*.d=:*.dart=:*.db=:*.deb=:*.diff=:*.dll=:*.doc=:*.docx=:*.dump=:*.edn=:*.efi=:*.ejs=:*.elf=:*.epub=:*.erl=:*.exe=:*.f#=:*.fifo=|:*.fish=:*.flac=:*.flv=:*.fs=:*.fsi=:*.fsscript=:*.fsx=:*.gem=:*.gif=:*.go=:*.gz=:*.gzip=:*.h=:*.hbs=:*.hrl=:*.hs=:*.htaccess=:*.htpasswd=:*.htm=:*.html=:*.ico=:*.img=:*.ini=:*.iso=:*.jar=:*.java=:*.jl=:*.jpeg=:*.jpg=:*.js=:*.json=:*.jsx=:*.key=:*.less=:*.lha=:*.lhs=:*.log=:*.lua=:*.lzh=:*.lzma=:*.m4a=:*.m4v=:*.markdown=:*.md=:*.mkv=:*.ml=λ:*.mli=λ:*.mov=:*.mp3=:*.mp4=:*.mpeg=:*.mpg=:*.msi=:*.mustache=:*.o=:*.ogg=:*.pdf=:*.php=:*.pl=:*.pm=:*.png=:*.pub=:*.ppt=:*.pptx=:*.psb=:*.psd=:*.py=:*.pyc=:*.pyd=:*.pyo=:*.rar=:*.rb=:*.rc=:*.rlib=:*.rom=:*.rpm=:*.rs=:*.rss=:*.rtf=:*.s=:*.so=:*.scala=:*.scss=:*.sh=:*.slim=:*.sln=:*.sql=:*.styl=:*.suo=:*.t=:*.tar=:*.tgz=:*.ts=:*.tsx=:*.twig=:*.vim=:*.vimrc=:*.wav=:*.webm=:*.xbps=:*.xhtml=:*.xls=:*.xlsx=:*.xml=:*.xul=:*.xz=:*.yaml=:*.yml=:*.zip=:'
