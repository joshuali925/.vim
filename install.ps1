# disable win+ctrl+shift+alt office key
REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop install git
scoop bucket add extras

scoop bucket add versions
scoop bucket add java
scoop install openjdk14
scoop install python
reg import "$env:USERPROFILE\scoop\apps\python\current\install-pep-514.reg"
scoop install nodejs@14.20.1
npm install yarn -g
echo "To install and switch other versions: scoop install openjdk17; scoop reset openjdk17"

scoop install 7zip
scoop install ripgrep
scoop install fzf
scoop install fd
scoop install lf
scoop install bat
scoop install delta
scoop install lazygit
scoop install vim
reg import "$env:USERPROFILE\scoop\apps\vim\current\install-context.reg"
scoop install windows-terminal
reg import "$env:USERPROFILE\scoop\apps\windows-terminal\current\install-context.reg"

scoop install clink
clink autorun install
clink set autosuggest.enable true
clink set cmd.ctrld_exits true
scoop install clink-flex-prompt

git clone https://github.com/joshuali925/.vim "$env:USERPROFILE\.vim" --depth=1
cmd /c mklink /J %USERPROFILE%\vimfiles %USERPROFILE%\.vim
mkdir "$env:APPDATA\lazygit"
mkdir "$env:LOCALAPPDATA\lf"
mkdir "$env:LOCALAPPDATA\Microsoft\Windows Terminal"
cmd /c mklink /H %USERPROFILE%\.gitconfig %USERPROFILE%\.vim\config\.gitconfig
cmd /c mklink /H %APPDATA%\lazlygit\config.yml %USERPROFILE%\.vim\config\lazygit_config.yml
copy "$env:USERPROFILE\.vim\config\lfrc" "$env:LOCALAPPDATA\lf\lfrc"
copy "$env:USERPROFILE\.vim\config\windows-terminal.json" "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
cmd /c "echo set previewer '' >> %LOCALAPPDATA%\lf\lfrc"
cmd /c "echo source ~/.vim/config/.bashrc >> %USERPROFILE%\.bashrc"
cmd /c "echo export EDITOR=vim VIM_SYSTEM_CLIPBOARD=1 >> %USERPROFILE%\.bashrc"

scoop install sudo
scoop bucket add nerd-fonts
sudo scoop install --global JetBrainsMono-NF

Remove-Item "$env:LOCALAPPDATA\nvim" -Force -Recurse -ErrorAction SilentlyContinue
robocopy $env:USERPROFILE\.vim\config\nvim $env:LOCALAPPDATA\nvim /e
Remove-Item "$env:LOCALAPPDATA\nvim\autoload" -Force -Recurse -ErrorAction SilentlyContinue
robocopy $env:USERPROFILE\.vim\autoload $env:LOCALAPPDATA\nvim\autoload /e

scoop install gow
