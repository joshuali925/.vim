# vim-configuration
## Download
```bash
mv ~/.vim ~/vim_backup
git clone https://github.com/joshuali925/vim-configuration.git ~/.vim
pip install --user flake8 yapf rope neovim pynvim jedi
```

## Set up vim
```bash
mkdir -p ~/.cache/vim/undo
vim -c "PlugInstall" -c "qa"
```

## Set up vim on Windows
```bash
# download 64-bit gvim from https://github.com/vim/vim-win32-installer/releases/latest
mkdir %USERPROFILE%\.cache\vim\undo
git clone https://github.com/joshuali925/vim-configuration.git %USERPROFILE%\vimfiles
vim -c "PlugInstall" -c "qa"
```

## Set up nvim
```bash
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin
ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
ln -s ~/.vim/autoload ~/.config/nvim/autoload
ln -s ~/.vim/colors ~/.config/nvim/colors
ln -s ~/.vim/plugged ~/.config/nvim/plugged
ln -s ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
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
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
ln -s .vim/.zshrc ~/.zshrc
ln -s .vim/.bashrc ~/.bashrc
ln -s ~/.vim/fish ~/.config/fish
ln -s .vim/.tmux.conf ~/.tmux.conf
```
