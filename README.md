# Dot Files
## Set up shell
```bash
cd ~
mkdir -p ~/.cache/vim/undo
mkdir -p ~/.local/bin
mkdir -p ~/.config/lf
git clone https://github.com/joshuali925/.vim.git ~/.vim

ln -s .vim/config/.bashrc ~/.bashrc
ln -s .vim/config/.zshrc ~/.zshrc
ln -s .vim/config/.tmux.conf ~/.tmux.conf
ln -s ~/.vim/config/lfrc ~/.config/lf/lfrc
ln -s ~/.vim/config/nvim ~/.config/nvim
ln -s ~/.vim/config/fish ~/.config/fish  # use fisher to manage fish plugins

# zsh inscure directories fix:
# compaudit | xargs chmod g-w
# compaudit | sudo xargs chmod -R 755
# zsh fast-syntax-highlighting theme:
# fast-theme clean
```

## Install
```bash
# vim
sudo add-apt-repository ppa:jonathonf/vim
sudo apt upgrade vim

# fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt install fish

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn
```

## Set up vim
```bash
pip3 install --user flake8 yapf
vim -c "PlugInstall" -c "qa"
```

## Set up vim on Windows
```bash
# download 64-bit gvim from https://github.com/vim/vim-win32-installer/releases/latest
mkdir %USERPROFILE%\.cache\vim\undo
git clone https://github.com/joshuali925/.vim.git %USERPROFILE%\vimfiles
vim -c "PlugInstall" -c "qa"
```

## Set up nvim
```bash
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage 
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root ~/.local/nvim
ln -s ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim
rm nvim.appimage

pip3 install --user neovim
nvim -c "PlugInstall" -c "qa"
```

## Mac OS
- set up utils
```
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install coreutils
brew install coreutils

# put in rc file
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
```
- set up shortcuts, option command shortcuts are for Karabiner
```markdown
Keyboard -> Shortcuts 
    -> Services -> Searching -> Look Up in Dictionary: option command t
    -> App Shortcuts -> Add new -> Tile Window to Right of Screen: control right
    -> App Shortcuts -> Add new -> Tile Window to Left of Screen: control left
    -> App Shortcuts -> Add new -> Zoom: control up
    -> App Shortcuts -> Add new -> Minimize: control down
    -> App Shortcuts -> Add new -> Enter Full Screen: control shift up
    -> App Shortcuts -> Add new -> Exit Full Screen: control shift up
iTerm2 -> Preferences -> Profiles -> Keys -> Presets... -> Natural Text Editing
Clipy -> Preferences -> Shortcuts -> History -> control shift v
```
- set up [Karabiner](https://karabiner-elements.pqrs.org/)
```bash
# visit this link to import settings
karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/joshuali925/.vim/master/config/karabiner.json

# or copy manually
mkdir -p ~/.config/karabiner/assets/complex_modifications
cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
```
then add complex modifications in Karabiner
