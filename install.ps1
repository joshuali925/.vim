# disable win+ctrl+shift+alt office key
REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop bucket add extras
scoop install git
scoop install mise ripgrep fzf fd yazi bat delta lazygit
Add-Content -Path "$env:USERPROFILE\.npmrc" -Value "prefix=$env:USERPROFILE\.local\lib\node-packages"

scoop install nu starship extras/carapace-bin zoxide
scoop install vim
reg import "$env:USERPROFILE\scoop\apps\vim\current\install-context.reg"

# sudo is needed for font installation script, built-in sudo won't work
scoop install sudo
scoop bucket add nerd-fonts
sudo scoop install --global JetBrainsMono-NF

scoop install clink
clink autorun install
clink set autosuggest.enable true
clink set cmd.ctrld_exits true
scoop install clink-flex-prompt
git clone --depth=1 https://github.com/vladimir-kotikov/clink-completions "$env:USERPROFILE\scoop\others\clink-completions"
cmd /c clink installscripts "$env:USERPROFILE\scoop\others\clink-completions"
git clone --depth=1 https://github.com/chrisant996/clink-gizmos "$env:USERPROFILE\scoop\others\clink-gizmos"
cmd /c clink installscripts "$env:USERPROFILE\scoop\others\clink-gizmos"

# install gow and setup deduped path
git clone --depth=1 https://github.com/joshuali925/gow -b main "$env:USERPROFILE\scoop\others\gow"
$env:Path >> "$env:USERPROFILE\scoop\others\PATH.bak"
[Environment]::SetEnvironmentVariable("Path", (([Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\.local\bin;$env:USERPROFILE\.local\lib\node-packages;$env:USERPROFILE\scoop\others\gow\bin" -split ";" | Select-Object -Unique) -join ";"), "User")
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\flexprompt_autoconfig.lua" "$env:USERPROFILE\scoop\apps\clink-flex-prompt\current\flexprompt_autoconfig.lua"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.cmd" "$env:USERPROFILE\scoop\apps\clink\current\z.cmd"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.lua" "$env:USERPROFILE\scoop\apps\clink\current\z.lua"

# add zsh from msys2
Invoke-WebRequest -Uri https://github.com/joshuali925/gow/releases/download/binaries/zsh-5.9-win64.zip -OutFile "$env:USERPROFILE\zsh.zip"
Expand-Archive -Path "$env:USERPROFILE\zsh.zip" -DestinationPath "$env:USERPROFILE\scoop\apps\git\current\usr" -Force
Remove-Item "$env:USERPROFILE\zsh.zip"

# add dot files
git clone --filter=blob:none https://github.com/joshuali925/.vim "$env:USERPROFILE\.vim"
[Environment]::SetEnvironmentVariable("RIPGREP_CONFIG_PATH", "$env:USERPROFILE\.vim\config\.ripgreprc", "User")
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", "$env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe", "User")
New-Item -ItemType Junction -Path "$env:USERPROFILE\vimfiles" -Target "$env:USERPROFILE\.vim"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.gitconfig" -Target "$env:USERPROFILE\.vim\config\.gitconfig"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.tmux.conf" -Target "$env:USERPROFILE\.vim\config\.tmux.conf"
New-Item -ItemType Junction -Path "$env:APPDATA\yazi\config" -Target "$env:USERPROFILE\.vim\config\yazi"
New-Item -ItemType Directory -Path "$env:APPDATA\lazygit"
New-Item -ItemType HardLink -Path "$env:APPDATA\lazygit\config.yml" -Target "$env:USERPROFILE\.vim\config\lazygit_config.yml"
Copy-Item "$env:USERPROFILE\.vim\config\windows-terminal.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
New-Item -ItemType Junction -Path "$env:APPDATA\nushell" -Target "$env:USERPROFILE\.vim\config\nushell"
nu "$env:USERPROFILE\.vim\config\nushell\bootstrap.nu"
Add-Content -Path "$env:USERPROFILE\.zshrc" -Value "source ~/.vim/config/zsh/.zshrc"
Add-Content -Path "$env:USERPROFILE\.zshrc" -Value "export EDITOR=vim TMUX_NO_TPM=1"
Add-Content -Path "$env:USERPROFILE\.bashrc" -Value "source ~/.vim/config/.bashrc"
Add-Content -Path "$env:USERPROFILE\.bashrc" -Value "export EDITOR=vim TMUX_NO_TPM=1"

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
