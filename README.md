# vim-configuration
## Set up vim
```bash
cd ~
git clone https://github.com/joshuali925/vim-configuration.git
mv vim-configuration .vim
ln -s .vim/.vimrc ~/.vimrc
mkdir -p .cache/vim/undo
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
pip install --user flake8 yapf rope neovim
nvim -c "PlugInstall" -c "qa"
```

## Set up shell
```bash
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
ln -s .vim/.zshrc ~/.zshrc
ln -s .vim/.bashrc ~/.bashrc
```
