# Dot Files

### Install tools and configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)"
```

### Run one-time bash with configs

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)"
```

### Windows

```bash
git clone https://github.com/joshuali925/.vim.git %USERPROFILE%\.vim --depth=1
copy %USERPROFILE%\.vim\config\.gitconfig %USERPROFILE%\.gitconfig
mkdir %USERPROFILE%\.vim\config\lfrc %LOCALAPPDATA%\lf
copy %USERPROFILE%\.vim\config\lfrc %LOCALAPPDATA%\lf\lfrc

# nvim
rmdir /S /Q %LOCALAPPDATA%\nvim
robocopy %USERPROFILE%\.vim\config\nvim %LOCALAPPDATA%\nvim /e
del %LOCALAPPDATA%\nvim\autoload
robocopy %USERPROFILE%\.vim\autoload %LOCALAPPDATA%\nvim\autoload /e
```

### Mac OS

- configs

```
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: command-option-t
         -> Text -> uncheck Use smart quotes and dashes

Maccy -> Preferences -> Hotkey -> control-shift-v
                     -> Paste automatically (command-shift-enter pastes without formatting)
                     -> History size 999
                     -> Appearance -> Menu size 100

Alt-tab -> Preferences -> Controls -> change "Hold option" to "Hold cmd"
                                   -> change "Select previous window" to shift tab
                       -> Appearance -> check Hide apps with no open window
```

- Surfingkeys settings https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js
