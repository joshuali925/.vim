# Dot Files ![](https://img.shields.io/github/repo-size/joshuali925/.vim?style=for-the-badge&label=SIZE&logo=codesandbox&color=8BD5CA&labelColor=302D41&logoColor=D9E0EE)

### Install tools and configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)"
```

### Run one-time bash with configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"
```

without downloading external binaries

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)" -- --no-binary-downloads
```

<details>
<summary>without downloading anything</summary>

copy base64 on local machine from github

```bash
curl -L -o- https://github.com/joshuali925/.vim/archive/master.tar.gz | tar xz -C /tmp --exclude=bin/busybox --exclude=config/backup.vim --exclude=config/surfingkeys.js --exclude=config/karabiner.json --exclude=config/nvim
echo "mkdir -p ~/.vim; base64 -d <<<$(tar cJf - -C /tmp .vim-master | base64 | tr -d '\r\n') | tar xvJ -C \"\$HOME/.vim\" --strip-components=1 && ~/.vim/bin/bashrc --no-binary-downloads" | pbcopy
rm -rf /tmp/.vim-master
```

or copy from local ~/.vim directory

```bash
echo "mkdir -p ~/.vim; base64 -d <<<$(cd ~/.vim > /dev/null 2>&1; git ls-files -- ':!bin/busybox' ':!config/backup.vim' ':!config/surfingkeys.js' ':!config/karabiner.json' ':!config/nvim' | tar cJf - -T - | base64 | tr -d '\r\n') | tar xvJ -C \"\$HOME/.vim\" && ~/.vim/bin/bashrc --no-binary-downloads" | pbcopy
```

paste and run in target machine

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

- configs

```
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: command-option-t
                      -> Input Sources: only keep "Select next source" as option-space
         -> Text -> uncheck Use smart quotes and dashes

Maccy -> Preferences -> Hotkey -> control-shift-v
                     -> Paste automatically (command-shift-enter pastes without formatting)
                     -> History size 999
                     -> Appearance -> Menu size 100

Alt-tab -> Preferences -> Controls -> change "Hold option" to "Hold cmd"
                                   -> change "Select previous window" to shift tab
                       -> Appearance -> check Hide apps with no open window
```

- Surfingkeys settings: https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js
