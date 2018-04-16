# vim-configuration
cd ~
git clone https://github.com/joshuali925/vim-configuration.git
mv vim-configuration .vim
rm .vim/plugged -r
ln -s .vim/.vimrc ~/.vimrc
vim -c "PlugInstall" -c "qa"


mkdir -p ~/.config/nvim
ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
ln -s ~/.vim/autoload ~/.config/nvim/autoload
ln -s ~/.vim/colors ~/.config/nvim/colors

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage 
chmod u+x nvim.appimage
mkdir -p ~/.local/bin
mv nvim.appimage ~/.local/bin/nvim

ln -s .vim/.zshrc ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

pip install --user flake8
pip install --user yapf
