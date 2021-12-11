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
mkdir %USERPROFILE%\.cache\nvim\undo
git clone https://github.com/joshuali925/.vim.git %USERPROFILE%\vimfiles --depth=1
mv %USERPROFILE%\vimfiles\config\nvim %LOCALAPPDATA%
rm %LOCALAPPDATA%\nvim\autoload
mv %USERPROFILE%\vimfiles\autoload %LOCALAPPDATA%\nvim\autoload
rm -rf %USERPROFILE%\vimfiles
```

### Mac OS

- configs

```markdown
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: option command t
         -> Text -> uncheck Use smart quotes and dashes
Maccy -> Preferences -> Hotkey -> control shift v
                     -> Paste automatically (cmd + shift + enter pastes without formatting)
                     -> History size 999
                     -> Appearance -> Menu size 100
Alt-tab -> Preferences -> Controls -> change "Hold option" to "Hold cmd"
                                   -> change "Select previous window" to shift tab
                       -> Appearance -> check Hide apps with no open window
```

- Surfingkeys settings https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js
- Karabiner settings [import](karabiner://karabiner/assets/complex_modifications/import?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjoshuali925%2F.vim%2FHEAD%2Fconfig%2Fkarabiner.json)

```bash
# click link above or copy manually
mkdir -p ~/.config/karabiner/assets/complex_modifications
cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
```

then add complex modifications in Karabiner
