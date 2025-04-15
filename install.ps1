# disable win+ctrl+shift+alt office key
REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
# ctr-d exit powershell
New-Item -ItemType Directory -Path ([System.IO.Path]::GetDirectoryName($Profile)) -Force
Add-Content -Path $Profile -Value "Set-PSReadLineKeyHandler -Key 'Ctrl+d' -Function DeleteCharOrExit"

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
scoop install git
scoop bucket add extras  # buckets rely on git
scoop bucket add nerd-fonts
scoop install yazi ripgrep fd fzf bat extras/lazygit delta mise nerd-fonts/JetBrainsMono-NF nu starship extras/carapace-bin zoxide
Add-Content -Path "$env:USERPROFILE\.npmrc" -Value "prefix=$env:USERPROFILE\.local\lib\node-packages"

# install gow and setup deduped path
git clone --depth=1 https://github.com/joshuali925/gow -b main "$env:USERPROFILE\scoop\others\gow"
$env:Path >> "$env:USERPROFILE\scoop\others\PATH.bak"
[Environment]::SetEnvironmentVariable("Path", (([Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\.local\bin;$env:USERPROFILE\.local\lib\node-packages;$env:LOCALAPPDATA\nvim-data\mason\bin;$env:USERPROFILE\scoop\others\gow\bin" -split ";" | Select-Object -Unique) -join ";"), "User")

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
Add-Content -Path "$env:USERPROFILE\.zshrc" -Value "source ~/.vim/config/zsh/.zshrc"
Add-Content -Path "$env:USERPROFILE\.bashrc" -Value "source ~/.vim/config/.bashrc"

scoop install neovim extras/neovide zig
reg import "$env:USERPROFILE\scoop\apps\neovide\current\install-context.reg"
Remove-Item "$env:LOCALAPPDATA\nvim" -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$env:USERPROFILE\.vim\config\nvim"
Remove-Item "$env:LOCALAPPDATA\nvim\autoload" -Force -Recurse
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim\autoload" -Target "$env:USERPROFILE\.vim\autoload"
nvim --headless +'Lazy! restore' +quitall
