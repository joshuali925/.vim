# Dot Files
## Set up shell
```bash
git clone https://github.com/joshuali925/.vim.git ~/.vim
mkdir -p ~/.cache/vim/undo ~/.local/bin ~/.config/lf ~/.config/jesseduffield/lazygit

echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
echo 'source ~/.vim/config/.zshrc' >> ~/.zshrc
echo 'skip_global_compinit=1' >> ~/.zshenv
ln -sr ~/.vim/config/.tmux.conf ~/.tmux.conf
ln -sr ~/.vim/config/.gitconfig ~/.gitconfig
ln -sr ~/.vim/config/lfrc ~/.config/lf/lfrc
ln -sr ~/.vim/config/nvim ~/.config/nvim
ln -sr ~/.vim/config/lazygit_config.yml ~/.config/jesseduffield/lazygit/config.yml
ln -sr ~/.vim/config/.ideavimrc ~/.ideavimrc

# zsh inscure directories fix:
# compaudit | xargs chmod g-w
# compaudit | sudo xargs chmod -R 755

# zsh fast-syntax-highlighting theme:
fast-theme clean
```

## Install
```bash
# dev environment
sudo apt update && sudo apt install -y zsh build-essential python3-dev python3-pip

# vim
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt upgrade -y vim

# neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root ~/.local/nvim
ln -sr ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim
rm nvim.appimage
pip3 install --user neovim

# tmux
curl -L https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b-x86_64.AppImage -o tmux.appimage
chmod u+x tmux.appimage
./tmux.appimage --appimage-extract
mv squashfs-root ~/.local/tmux
ln -sr ~/.local/tmux/usr/bin/tmux ~/.local/bin/tmux
rm tmux.appimage

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# pathpicker
git clone https://github.com/facebook/PathPicker.git ~/.local/PathPicker --depth=1
ln -sr ~/.local/PathPicker/fpp ~/.local/bin/fpp
```

## Windows
```bash
# vim
# download 64-bit gvim from https://github.com/vim/vim-win32-installer/releases/latest
mkdir %USERPROFILE%\.cache\vim\undo
git clone https://github.com/joshuali925/.vim.git %USERPROFILE%\vimfiles
```

## Mac OS
- set up utils
```bash
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install gnu coreutils and sed, override default utils
brew install coreutils
brew install gnu-sed
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
ln -sr $(command which gsed) ~/.local/bin/sed

# add lazygit config
ln -sr ~/.vim/config/lazygit_config.yml ~/Library/Application\ Support/jesseduffield/lazygit/config.yml

# link .zshrc for MacVim
ln -s ~/.zshrc ~/.zprofile

# install applications
brew cask install iterm2
brew cask install rectangle
brew cask install maccy
brew cask install karabiner-elements
brew cask install visual-studio-code
```
- configs
```markdown
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: option command t
                      -> App Shortcuts -> Add -> iTerm -> Clear Buffer: command shift k
iTerm2 -> Preferences -> Keys -> Key Bindings -> Add -> Select Split Pane Left/Below/Above/Right: command h/j/k/l
                      -> Profiles -> Keys -> Presets... -> Natural Text Editing
                                  -> General -> Working Directory -> Advanced Configuration -> Working Directory for New Split Panes -> Reuse previous session's directory
                                  -> Terminal -> uncheck Save lines to scrollback in alternative screen mode
                                              -> Scrollback lines -> 10000
                                  -> Advanced -> Semantic History -> Run command -> open -a MacVim \1
Maccy -> Preferences -> Hotkey -> control shift v
      -> Behavior -> Paste automatically (cmd + shift + enter pastes without formatting)
      -> History size -> 999
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
