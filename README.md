# Dot Files ![](https://img.shields.io/github/repo-size/joshuali925/.vim?style=for-the-badge&label=SIZE&logo=codesandbox&color=8BD5CA&labelColor=302D41&logoColor=D9E0EE)

### Install tools and configs

```bash
time bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)" && SHELL=$(which zsh) exec zsh
```

### Run bash with configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"
```

Without downloading external binaries

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)" -- --no-binary-downloads
```

<details>
<summary>Without downloading anything</summary>

Copy base64 on local machine from github

```bash
curl -L -o- https://github.com/joshuali925/.vim/archive/master.tar.gz | tar xz -C /tmp --exclude=bin/busybox --exclude=config/surfingkeys.js --exclude=config/hammerspoon --exclude=config/nvim --exclude=config/zsh
echo "mkdir -p ~/.vim; base64 -d <<<$(tar cJf - -C /tmp .vim-master | base64 | tr -d '\r\n') | tar xvJ -C \"\$HOME/.vim\" --strip-components=1 && ~/.vim/bin/bashrc --no-binary-downloads" | pbcopy
rm -rf /tmp/.vim-master
```

or copy from local ~/.vim directory

```bash
echo "mkdir -p ~/.vim; base64 -d <<<$(cd ~/.vim > /dev/null 2>&1; git ls-files -- ':!bin/busybox' ':!config/surfingkeys.js' ':!config/hammerspoon' ':!config/nvim' ':!config/zsh' | tar cJf - -T - | base64 | tr -d '\r\n') | tar xvJ -C \"\$HOME/.vim\" && ~/.vim/bin/bashrc --no-binary-downloads" | pbcopy
```

paste and run in target machine. To transfer through ssh, change `pbcopy` to `ssh <host> bash`.

</details>

### Run alpine docker environment

```bash
docker run -e TERM --network host -w /root -it --rm alpine:edge sh -uelic '
  apk add curl bash vim
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"'
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.ps1 | iex
```

### Mac OS

- Configs

```
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: command-option-t
                      -> Input Sources: only keep "Select next source" as option-space
                      -> Mission Control: change "Move left a space" and "Move right a space" to control-option-command-left and control-option-command-right
                      -> Keyboard: Move focus to next window: command-option-tab

Trackpad -> Point & Click -> Set "Tracking speed" to 8, "Click" to "Light", enable "Tap to click"
         -> More Gestures -> Set "Swipe between full-screen applications", "Mission Control" to Off

Spotlight -> Uncheck all except Calculator, Calendar, Dictionary, System Settings, Apps, Menu Items

Maccy -> Preferences -> Hotkey -> control-shift-v
                     -> Paste automatically (command-shift-enter pastes without formatting)
                     -> History size 999

BetterTouchTool -> Settings -> Trackpad -> Swipes -> 3 & 4 Finger Swipes -> Set all sensitivity to 0.12

Handy -> General -> Transcribe -> change to right cmd
```

- Surfingkeys settings: https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js
