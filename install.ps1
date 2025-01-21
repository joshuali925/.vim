# disable win+ctrl+shift+alt office key
REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop install git
scoop bucket add extras

scoop bucket add versions
scoop bucket add java
scoop install openjdk14
scoop install python
reg import "$env:USERPROFILE\scoop\apps\python\current\install-pep-514.reg"
scoop install nodejs18@18.19.0
npm install yarn -g
echo "To install and switch other versions: scoop install openjdk17; scoop reset openjdk17"

scoop install ripgrep
scoop install fzf
scoop install fd
scoop install yazi
scoop install bat
scoop install delta
scoop install lazygit
scoop install vim
reg import "$env:USERPROFILE\scoop\apps\vim\current\install-context.reg"

scoop install clink
clink autorun install
clink set autosuggest.enable true
clink set cmd.ctrld_exits true
scoop install clink-flex-prompt
git clone --depth=1 https://github.com/vladimir-kotikov/clink-completions "$env:USERPROFILE\scoop\others\clink-completions"
cmd /c clink installscripts "$env:USERPROFILE\scoop\others\clink-completions"
git clone --depth=1 https://github.com/chrisant996/clink-gizmos "$env:USERPROFILE\scoop\others\clink-gizmos"
cmd /c clink installscripts "$env:USERPROFILE\scoop\others\clink-gizmos"

# clone gow and add gow\bin to deduped path
git clone https://github.com/joshuali925/gow --single-branch -b main --depth=1 "$env:USERPROFILE\scoop\others\gow"
$env:Path >> "$env:USERPROFILE\scoop\others\PATH.bak"
[Environment]::SetEnvironmentVariable("Path", (([Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\scoop\others\gow\bin" -split ";" | Select-Object -Unique) -join ";"), "User")
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\config\flexprompt_autoconfig.lua" "$env:USERPROFILE\scoop\apps\clink-flex-prompt\current\flexprompt_autoconfig.lua"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.cmd" "$env:USERPROFILE\scoop\apps\clink\current\z.cmd"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.lua" "$env:USERPROFILE\scoop\apps\clink\current\z.lua"

# add zsh from msys2
Invoke-WebRequest -Uri https://github.com/joshuali925/gow/releases/download/binaries/zsh-5.9-win64.zip -OutFile "$env:USERPROFILE\zsh.zip"
Expand-Archive -Path "$env:USERPROFILE\zsh.zip" -DestinationPath "$env:USERPROFILE\scoop\apps\git\current\usr" -Force
Remove-Item "$env:USERPROFILE\zsh.zip"

git clone --filter=blob:none https://github.com/joshuali925/.vim "$env:USERPROFILE\.vim"
[Environment]::SetEnvironmentVariable("RIPGREP_CONFIG_PATH", "$env:USERPROFILE\.vim\config\.ripgreprc", "User")
cmd /c mklink /J %USERPROFILE%\vimfiles %USERPROFILE%\.vim
New-Item -ItemType Directory -Path "$env:APPDATA\lazygit"
cmd /c mklink /H %USERPROFILE%\.gitconfig %USERPROFILE%\.vim\config\.gitconfig
cmd /c mklink /H %USERPROFILE%\.tmux.conf %USERPROFILE%\.vim\config\.tmux.conf
cmd /c mklink /H %APPDATA%\lazygit\config.yml %USERPROFILE%\.vim\config\lazygit_config.yml
Copy-Item "$env:USERPROFILE\.vim\config\yazi" "$env:APPDATA\yazi\config" -Recurse
Copy-Item "$env:USERPROFILE\.vim\config\windows-terminal.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
cmd /c "echo source ~/.vim/config/zsh/.zshrc >> %USERPROFILE%\.zshrc"
cmd /c "echo export EDITOR=vim TMUX_NO_TPM=1 >> %USERPROFILE%\.zshrc"
cmd /c "echo source ~/.vim/config/.bashrc >> %USERPROFILE%\.bashrc"
cmd /c "echo export EDITOR=vim TMUX_NO_TPM=1 >> %USERPROFILE%\.bashrc"

scoop install sudo
scoop bucket add nerd-fonts
sudo scoop install --global JetBrainsMono-NF

Remove-Item "$env:LOCALAPPDATA\nvim" -Force -Recurse -ErrorAction SilentlyContinue
Copy-Item "$env:USERPROFILE\.vim\config\nvim" "$env:LOCALAPPDATA\nvim" -Recurse
Remove-Item "$env:LOCALAPPDATA\nvim\autoload" -Force -Recurse
Copy-Item "$env:USERPROFILE\.vim\autoload" "$env:LOCALAPPDATA\nvim\autoload" -Recurse

## enable sshd on ec2
if ((Get-WmiObject -Class Win32_ComputerSystem).Manufacturer -match 'Amazon EC2') {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Set-Service -Name sshd -StartupType 'Automatic'
    Start-Service sshd
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:USERPROFILE\scoop\shims\bash.exe" -PropertyType String -Force
}
