# vim-configuration
## Download
```bash
mv ~/.vim ~/vim_backup
git clone https://github.com/joshuali925/vim-configuration.git ~/.vim
pip install --user flake8 yapf rope neovim pynvim jedi
```

## Set up vim
```bash
cd ~
mkdir -p .cache/vim/undo
ln -s .vim/.vimrc ~/.vimrc
vim -c "PlugInstall" -c "qa"
```

## Set up nvim
```bash
mkdir -p ~/.config/nvim
ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
ln -s ~/.vim/autoload ~/.config/nvim/autoload
ln -s ~/.vim/colors ~/.config/nvim/colors
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage 
chmod u+x nvim.appimage
mkdir -p ~/.local/bin
mv nvim.appimage ~/.local/bin/nvim
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
```
