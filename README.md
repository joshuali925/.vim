# Dot Files ![](https://img.shields.io/github/repo-size/joshuali925/.vim?style=for-the-badge&label=SIZE&logo=codesandbox&color=8BD5CA&labelColor=302D41&logoColor=D9E0EE)

### Install tools and configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)"
```

### Run one-time bash with configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"
```

### Run alpine docker environment

```bash
docker run -e TERM --network host -w /root -it --rm alpine sh -c '
  apk add curl bash vim
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"'
```

### Windows (PowerShell)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
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
