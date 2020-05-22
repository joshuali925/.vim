# Dot Files
## Download
```bash
cd ~
mkdir -p ~/.cache/vim/undo
mkdir -p ~/.local/bin
mkdir -p ~/.config
git clone https://github.com/joshuali925/.vim.git ~/.vim
```

## Installl
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

ln -s ~/.vim/config/nvim ~/.config/nvim
pip3 install --user neovim
nvim -c "PlugInstall" -c "qa"
```

## Set up shell
```bash
ln -s .vim/config/.bashrc ~/.bashrc
ln -s ~/.vim/config/fish ~/.config/fish  # use fisher to manage fish plugins
mkdir -p ~/.config/lf
ln -s ~/.vim/config/lfrc ~/.config/lf/lfrc
ln -s .vim/config/.tmux.conf ~/.tmux.conf
```

## Set up zsh
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/zsh/zsh-history-substring-search
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/zsh/powerlevel10k
ln -s .vim/config/.zshrc ~/.zshrc
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
- set up shortcuts for Karabiner
```markdown
Keyboard -> Shortcuts 
    -> Services -> Searching -> Look Up in Dictionary: option command t
    -> App Shortcuts -> Add new -> Tile Window to Right of Screen: option command ]
    -> App Shortcuts -> Add new -> Tile Window to Left of Screen: option command [
    -> App Shortcuts -> Add new -> Zoom: option command =
iTerm2 -> Preferences -> Profiles -> Keys -> Presets... -> Natural Text Editing
Clipy -> Preferences -> Shortcuts -> History -> option command p
```
- set up Karabiner
```bash
# visit this link to import settings
karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/joshuali925/.vim/master/config/karabiner.json

# or copy manually
mkdir -p ~/.config/karabiner/assets/complex_modifications
cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/14594837.json
```
then add complex modifications
