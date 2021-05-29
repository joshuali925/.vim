# Dot Files
## Set up shell
```bash
cd
git clone https://github.com/joshuali925/.vim.git ~/.vim --depth 1
mkdir -p ~/.cache/vim/undo ~/.local/bin ~/.config/jesseduffield/lazygit ~/.config/{lf,bpytop}
echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
echo 'source ~/.vim/config/.zshrc' >> ~/.zshrc
echo 'skip_global_compinit=1' >> ~/.zshenv
ln -s ~/.vim/config/.tmux.conf ~/.tmux.conf
ln -s ~/.vim/config/.gitconfig ~/.gitconfig
ln -s ~/.vim/config/lfrc ~/.config/lf/lfrc
ln -s ~/.vim/config/nvim ~/.config/nvim
ln -s ~/.vim/config/lazygit_config.yml ~/.config/jesseduffield/lazygit/config.yml
ln -s ~/.vim/config/.ideavimrc ~/.ideavimrc

# zsh fast-syntax-highlighting theme:
fast-theme clean

# zsh inscure directories fix:
# compaudit | xargs chmod g-w
# compaudit | sudo xargs chmod -R 755

# ssh key
ssh-keygen -t ed25519 -C "email@example.com"
cat ~/.ssh/id_ed25519.pub  # copy and add in https://github.com/settings/keys
```

## Install
```bash
# centos environment
sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh python3

# ubuntu environment
sudo apt update && sudo apt install -y zsh build-essential python3-dev python3-pip

# pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py

# change default shell to zsh
sudo chsh -s $(which zsh) $(whoami)
# or run zsh when bash starts
sed -i -e '1i[ -t 1 ] && exec zsh\' ~/.bashrc

# nvm, node, yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install 10.23.1 && node --version && ln -s $(which node) ~/.local/bin/node
curl -o- -L https://yarnpkg.com/install.sh | bash
ln -s ~/.yarn/bin/yarn ~/.local/bin/yarn

# vim
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt upgrade -y vim

# neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract && rm nvim.appimage
mv squashfs-root ~/.local/nvim && ln -s ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim
pip3 install --user pynvim
# need to export after p10k instant prompt loads
echo "export \$EDITOR='nvim'" >> ~/.zshrc

# install vscode-neovim plugins
nvim -u ~/.vim/config/vscode.vim +PlugInstall +quitall

# tmux
curl -L https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b-x86_64.AppImage -o tmux.appimage
chmod u+x tmux.appimage && ./tmux.appimage --appimage-extract && rm tmux.appimage
mv squashfs-root ~/.local/tmux && ln -s ~/.local/tmux/usr/bin/tmux ~/.local/bin/tmux

# pathpicker
git clone https://github.com/facebook/PathPicker.git ~/.local/PathPicker --depth=1
ln -s ~/.local/PathPicker/fpp ~/.local/bin/fpp

# bpytop
python3 -m venv ~/.local/bpytop && source ~/.local/bpytop/bin/activate && pip install bpytop && deactivate
echo 'color_theme="dracula"' >> ~/.config/bpytop/bpytop.conf && echo 'show_init=False' >> ~/.config/bpytop/bpytop.conf
ln -s ~/.local/bpytop/bin/bpytop ~/.local/bin/bpytop
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

# install gnu utils and override default utils
brew info coreutils  # check path of gnubin
brew install coreutils && echo 'export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH' >> ~/.zshrc
brew install gnu-sed && ln -s $(which gsed) ~/.local/bin/sed
brew install findutils && ln -s $(which gxargs) ~/.local/bin/xargs
brew install gawk && ln -s $(which gawk) ~/.local/bin/awk

# add lazygit config
mkdir -p ~/Library/Application\ Support/jesseduffield/lazygit
ln -s ~/.vim/config/lazygit_config.yml ~/Library/Application\ Support/jesseduffield/lazygit/config.yml

# link .zshrc for MacVim
ln -s ~/.zshrc ~/.zprofile

# enable key repeats
defaults write -g ApplePressAndHoldEnabled -bool false

# install applications
brew install --cask iterm2 rectangle maccy karabiner-elements alt-tab visual-studio-code
```
- configs
```markdown
Keyboard -> Shortcuts -> Services -> Searching -> Look Up in Dictionary: option command t
                      -> App Shortcuts -> Add -> iTerm -> Clear Buffer: command shift k
iTerm2 -> Preferences -> Keys -> Key Bindings -> Change next/previous tab to C-Tab and C-S-Tab
                      -> Profiles -> Keys -> Presets... -> Natural Text Editing (need to clear mission control C-Left/Right shortcuts)
                                  -> General -> Working Directory -> Advanced Configuration -> Working Directory for New Split Panes -> Reuse previous session's directory
                                  -> Terminal -> uncheck Save lines to scrollback in alternative screen mode
                                              -> Scrollback lines 10000
                                  -> Advanced -> Semantic History -> Run command -> open -a MacVim \1
Maccy -> Preferences -> Hotkey -> control shift v
                     -> Paste automatically (cmd + shift + enter pastes without formatting)
                     -> History size 999
                     -> Appearance -> Menu size 100
Alt-tab -> Preferences -> Controls -> change "Hold option" to "Hold cmd"
                                   -> change "Select previous window" to shift tab
                       -> Appearance -> check Hide apps with no open window
```
- Karabiner settings [import](karabiner://karabiner/assets/complex_modifications/import?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjoshuali925%2F.vim%2Fmaster%2Fconfig%2Fkarabiner.json)
```bash
# click link above or copy manually
mkdir -p ~/.config/karabiner/assets/complex_modifications
cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
```
then add complex modifications in Karabiner
