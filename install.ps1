# disable win+ctrl+shift+alt office key
REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /f /t REG_SZ /d rundll32
# use old context menu
REG ADD "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
# disable folder type detection
Set-ItemProperty HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell -Name FolderType -Value NotSpecified -Type String -Force
# disable bing search
Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Value 0 -Type DWord -Force
# ctr-d exit powershell
New-Item -ItemType Directory -Path ([System.IO.Path]::GetDirectoryName($Profile)) -Force
Add-Content -Path $Profile -Value "Set-PSReadLineKeyHandler -Key 'Ctrl+d' -Function DeleteCharOrExit"

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
} else {
    irm get.scoop.sh | iex
}
scoop install git
scoop bucket add extras  # buckets rely on git
scoop bucket add nerd-fonts
scoop install yazi ripgrep fd fzf bat extras/lazygit delta mise nerd-fonts/Maple-Mono-NF-CN nu starship extras/carapace-bin zoxide
Add-Content -Path "$env:USERPROFILE\.npmrc" -Value "prefix=$env:USERPROFILE\.local\lib\node-packages"

# install gow and setup deduped path
git clone --depth=1 https://github.com/joshuali925/gow -b main "$env:USERPROFILE\scoop\others\gow"
$env:Path >> "$env:USERPROFILE\scoop\others\PATH.bak"
[Environment]::SetEnvironmentVariable("Path", (([Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\.local\bin;$env:USERPROFILE\.local\lib\node-packages;$env:LOCALAPPDATA\mise\shims;$env:LOCALAPPDATA\nvim-data\mason\bin;$env:USERPROFILE\scoop\others\gow\bin" -split ";" | Select-Object -Unique) -join ";"), "User")

# add zsh from msys2
Invoke-WebRequest -Uri https://github.com/joshuali925/gow/releases/download/binaries/zsh-5.9-win64.zip -OutFile "$env:USERPROFILE\zsh.zip"
Expand-Archive -Path "$env:USERPROFILE\zsh.zip" -DestinationPath "$env:USERPROFILE\scoop\apps\git\current\usr" -Force
Remove-Item "$env:USERPROFILE\zsh.zip"

# install clink
scoop install clink clink-flex-prompt
clink autorun install
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\flexprompt_autoconfig.lua" "$env:USERPROFILE\scoop\apps\clink-flex-prompt\current\flexprompt_autoconfig.lua"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.cmd" "$env:USERPROFILE\scoop\apps\clink\current\z.cmd"
Copy-Item "$env:USERPROFILE\scoop\others\gow\clink_related\z.lua" "$env:USERPROFILE\scoop\apps\clink\current\z.lua"

# add dot files
git clone --filter=blob:none https://github.com/joshuali925/.vim "$env:USERPROFILE\.vim"
[Environment]::SetEnvironmentVariable("RIPGREP_CONFIG_PATH", "$env:USERPROFILE\.vim\config\.ripgreprc", "User")
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", "$env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe", "User")
New-Item -ItemType Junction -Path "$env:USERPROFILE\vimfiles" -Target "$env:USERPROFILE\.vim"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.gitconfig" -Target "$env:USERPROFILE\.vim\config\.gitconfig"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.tmux.conf" -Target "$env:USERPROFILE\.vim\config\.tmux.conf"
New-Item -ItemType Junction -Path "$env:APPDATA\yazi\config" -Target "$env:USERPROFILE\.vim\config\yazi"
New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\lazygit"
New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\lazygit\config.yml" -Target "$env:USERPROFILE\.vim\config\lazygit_config.yml"
Copy-Item "$env:USERPROFILE\.vim\config\windows-terminal.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
New-Item -ItemType Junction -Path "$env:APPDATA\nushell" -Target "$env:USERPROFILE\.vim\config\nushell"
nu "$env:USERPROFILE\.vim\config\nushell\bootstrap.nu"
Add-Content -Path "$env:USERPROFILE\.zshrc" -Value "export LANG=C.UTF-8", "source ~/.vim/config/zsh/.zshrc"
Add-Content -Path "$env:USERPROFILE\.bashrc" -Value "export LANG=C.UTF-8", "source ~/.vim/config/.bashrc"

# install neovim
scoop install neovim extras/neovide gcc
reg import "$env:USERPROFILE\scoop\apps\neovide\current\install-context.reg"
Remove-Item "$env:USERPROFILE\.vim\config\nvim\autoload" -Force -Recurse
New-Item -ItemType Junction -Path "$env:USERPROFILE\.vim\config\nvim\autoload" -Target "$env:USERPROFILE\.vim\autoload"
git -C "$env:USERPROFILE\.vim" update-index --skip-worktree config/nvim/autoload
Add-Content -Path "$env:USERPROFILE\.vim\.git\info\exclude" -Value "/config/nvim/autoload"
Remove-Item "$env:LOCALAPPDATA\nvim" -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$env:USERPROFILE\.vim\config\nvim"
nvim --headless +"Lazy! restore" +quitall
