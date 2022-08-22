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
# nvim
git clone https://github.com/joshuali925/.vim.git %USERPROFILE%\vimfiles --depth=1
move %USERPROFILE%\vimfiles\config\nvim %LOCALAPPDATA%
del %LOCALAPPDATA%\nvim\autoload
move %USERPROFILE%\vimfiles\autoload %LOCALAPPDATA%\nvim\autoload
rmdir /S /Q %USERPROFILE%\vimfiles
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
