# Dot Files
## Download
```bash
cd ~
mkdir -p ~/.cache/vim/undo
mkdir -p ~/.local/bin
mkdir -p ~/.config
mv ~/.vim ~/vim_backup
git clone https://github.com/joshuali925/.vim.git ~/.vim
pip install --user flake8 yapf rope neovim pynvim jedi
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
ln -s ~/.vim/config/nvim ~/.config/nvim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage 
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root ~/.local/nvim
ln -s ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim
rm nvim.appimage
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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
ln -s .vim/config/.zshrc ~/.zshrc
```
