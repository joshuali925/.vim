#!/usr/bin/env bash

set -e
cd "$HOME"

NVM_VERSION=0.38.0
# NODE_VERSION=10.24.1
NODE_VERSION=14.17.5
DOCKER_COMPOSE_VERSION=1.29.2
BACKUP_DIR=$HOME/config-backup

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLACK="\033[1;30m"
NC='\033[0m'

unameOut="$(uname -s)"
architecture="$(uname -m)"
if [ $architecture == 'amd64' ]; then
  architecture='x86_64'
fi
case "${unameOut}" in
  Linux*)
    if [ -x "$(command -v yum)" ]; then
      platform=Linux:yum
    elif [ -x "$(command -v apt)" ]; then
      platform=Linux:apt
    else
      platform=Linux
    fi
    ;;
  Darwin*)    platform=MacOS;;
  *)          platform="UNKNOWN:${unameOut}"
esac

log() {
  echo -e "${CYAN}${@}${NC}"
}

usage() {
  echo "usage: bash install.sh [install <package>,...]"
  echo "  package list: devtools, dotfiles, docker, java, python, node, tmux, neovim, ssh-key"
}

backup() {
  if [[ -a "$1" ]]; then
    mkdir -p "$BACKUP_DIR"
    # mv -v --backup=t "$1" "$BACKUP_DIR/$(basename ${1}).backup"
    mv -v "$1" "$BACKUP_DIR/$(basename ${1}).backup"
  fi
}

link_file() {
  local sourceFile="$1" destFile="$2"
  backup "$destFile"
  ln -s "$sourceFile" "$destFile"
  log "Linked $sourceFile to $destFile"
}

install_development_tools() {
  log "\nInstalling development tools.."
  if [ $platform == 'Linux:yum' ]; then
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh
  elif [ $platform == 'Linux:apt' ]; then
    sudo apt update && sudo apt install -y build-essential zsh
  elif [ $platform == 'MacOS' ]; then
    mkdir -pv ~/.local/bin
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install coreutils
    echo "export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH" >> ~/.zshrc
    echo "export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH" >> ~/.bashrc
    brew install gnu-sed && ln -s $(which gsed) ~/.local/bin/sed
    brew install findutils && ln -s $(which gxargs) ~/.local/bin/xargs
    brew install gawk && ln -s $(which gawk) ~/.local/bin/awk
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    log "Installed homebrew and packages, exported to ~/.zshrc and ~/.bashrc"
    defaults write -g ApplePressAndHoldEnabled -bool false  # enable key repeats
    log "Disabled ApplePressAndHoldEnabled to support key repeats"
    # brew install --cask iterm2 rectangle maccy karabiner-elements alt-tab visual-studio-code
  fi
}

install_docker() {
  if [ $platform == 'Linux:yum' ]; then
    sudo yum install -y docker
  elif [ $platform == 'Linux:apt' ]; then
    curl -fsSL https://get.docker.com/ | sh
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed docker, adding permissions.."
  sudo groupadd docker || true
  sudo usermod -aG docker $USER
  sudo systemctl restart docker || sudo service docker restart
  log "Installing docker-compose.."
  sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  log "Installed, re-login and run ${YELLOW}docker info${CYAN} for status"
}

install_java() {
  # https://github.com/shyiko/jabba/blob/3bb7cca8389753072e9f6fbb9fee6fdfa85ca57f/index.json#L833
  if [[ $platform == Linux* ]]; then
    if [ $architecture == 'x86_64' ]; then
      curl -L -o- https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz | tar -xz -C $HOME/.local
      jdk_version=jdk-14.0.1
    else
      curl -L -o- https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.1_9.tar.gz | tar -xz -C $HOME/.local
      jdk_version=jdk-16.0.1+9
    fi
    echo "export PATH=\$HOME/.local/$jdk_version/bin:\$PATH" >> ~/.zshrc
    echo "export JAVA_HOME=\$HOME/.local/$jdk_version" >> ~/.zshrc
  elif [ $platform == 'MacOS' ]; then
    brew tap AdoptOpenJDK/openjdk
    brew install --cask adoptopenjdk14
    jdk_version=jdk-14
    echo "export JAVA_HOME=$(/usr/libexec/java_home)" >> ~/.zshrc
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed $jdk_version, exported JAVA_HOME to ~/.zshrc, restart your shell"
}

install_python() {
  if [ $platform == 'Linux:yum' ]; then
    sudo yum install -y python3
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
  elif [ $platform == 'Linux:apt' ]; then
    sudo apt update && sudo apt install -y python3-dev python3-pip python3-venv
  elif [ $platform != 'MacOS' ]; then
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed python3 and pip3"
  python3 -m venv ~/.local/python-packages
  source ~/.local/python-packages/bin/activate && pip install bpytop && deactivate
  echo -e "color_theme=\"dracula\"\nshow_init=False" >> ~/.config/bpytop/bpytop.conf
  ln -s ~/.local/python-packages/bin/bpytop ~/.local/bin/bpytop
  git clone https://github.com/facebook/PathPicker.git ~/.local/python-packages/PathPicker --depth=1
  ln -s ~/.local/python-packages/PathPicker/fpp ~/.local/bin/fpp
  log "Installed bpytop, fpp"
}

install_dotfiles() {
  log "\nCloning dotfiles.."
  backup "$HOME/.vim"
  git clone https://github.com/joshuali925/.vim.git $HOME/.vim --depth 1
  log "\nCreating directories.."
  mkdir -pv ~/.cache/{n,}vim/undo ~/.local/{bin,node-packages,share/lf} ~/.config/{lf,bpytop,lazygit}
  log "\nLinking configurations.."
  echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
  echo 'source ~/.vim/config/.zshrc' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  log "Appended 'source ~/.vim/config/.bashrc' to ~/.bashrc"
  log "Appended 'source ~/.vim/config/.zshrc' to ~/.zshrc"
  log "Appended 'skip_global_compinit=1' to ~/.zshenv"
  link_file $HOME/.vim/config/.tmux.conf $HOME/.tmux.conf
  link_file $HOME/.vim/config/.gitconfig $HOME/.gitconfig
  link_file $HOME/.vim/config/lfrc $HOME/.config/lf/lfrc
  link_file $HOME/.vim/config/nvim $HOME/.config/nvim
  link_file $HOME/.vim/config/lazygit_config.yml $HOME/.config/lazygit/config.yml
  link_file $HOME/.vim/config/.ideavimrc $HOME/.ideavimrc
  if [ $platform == 'MacOS' ]; then
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link_file $HOME/.vim/config/lazygit_config.yml $HOME/Library/ApplicationSupport/lazygit/config.yml
    link_file $HOME/Library/ApplicationSupport/Code/User/snippets $HOME/.config/snippets  # use vscode snipets for neovim
    # link_file $HOME/.zshrc $HOME/.zprofile  # link .zshrc for MacVim
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
    log "Linked configs for MacOS"
  fi
  echo
}

install_tmux() {
  log "Installing tmux.."
  if [[ $platform == Linux* ]]; then
    if [ $architecture == 'x86_64' ]; then
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-linux-x86_64.tar.gz | tar xz -C $HOME/.local/bin tmux
    else
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-linux-arm64.tar.gz | tar xz -C $HOME/.local/bin tmux
    fi
  elif [ $platform == 'MacOS' ]; then
    brew install tmux --HEAD
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installing tmux plugins.."
  backup "$HOME/.tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth 1
  ~/.tmux/plugins/tpm/bin/install_plugins || true
  if [[ -a "$HOME/.tmux/plugins/tmux-thumbs" ]]; then
    log "Installing tmux-thumbs binaries.."
    if [[ $platform == Linux* ]]; then
      if [ $architecture == 'x86_64' ]; then
        curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-linux-x86_64.tar.gz | tar xz -C $HOME/.tmux/plugins/tmux-thumbs
      else
        curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-linux-arm64.tar.gz | tar xz -C $HOME/.tmux/plugins/tmux-thumbs
      fi
    elif [ $platform == 'MacOS' ]; then
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-darwin-x86_64.tar.gz | tar xz -C $HOME/.tmux/plugins/tmux-thumbs
    fi
  fi
  echo
}

install_node() {
  log "\nInstalling nvm.."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash
  NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  log "Installing node $NODE_VERSION.."
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
  node --version && ln -sf $(which node) ~/.local/bin/node && ln -sf $(which npm) ~/.local/bin/npm
  log "Installing yarn.."
  curl -o- -L https://yarnpkg.com/install.sh | bash
  ln -sf ~/.yarn/bin/yarn ~/.local/bin/yarn
  log "Installing node packages.."
  pushd ~/.local/node-packages
  ~/.yarn/bin/yarn add prettier || true
  ~/.yarn/bin/yarn add fixjson || true
  ~/.yarn/bin/yarn add lua-fmt || true
  popd
  echo
}

install_neovim() {
  if [[ $platform == Linux* ]]; then
    backup "$HOME/.local/nvim"
    if [ $architecture == 'x86_64' ]; then
      curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
      chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract && rm nvim.appimage
      mv squashfs-root ~/.local/nvim && ln -sf ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim
    else
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/neovim-linux-arm64.tar.gz | tar xz -C ~/.local nvim
      ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
    fi
  elif [ $platform == 'MacOS' ]; then
    backup "$HOME/.local/nvim-osx64"
    curl -L -o- https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz | tar xz -C ~/.local
    ln -sf ~/.local/nvim-osx64/bin/nvim ~/.local/bin/nvim
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed neovim, installing plugins.."
  # https://github.com/wbthomason/packer.nvim/issues/198#issuecomment-817426007
  sh -c 'sleep 120 && pkill nvim && echo "Timeout, killed neovim"' &
  local pid=$!
  ~/.local/bin/nvim --headless -u NORC --noplugin +"autocmd User PackerComplete quitall" +"silent lua require('plugins').install()" || true
  kill $pid > /dev/null 2>&1 || true
  sh -c 'sleep 30 && pkill nvim && echo "Timeout, killed neovim"' &
  pid=$!
  ~/.local/bin/nvim --headless +"lua vim.defer_fn(function() vim.cmd('quitall') end, 27000)" || true
  kill $pid > /dev/null 2>&1 || true
  log "\nInstalled neovim plugins, run ${YELLOW}:LspInstallAll${CYAN} in neovim to install language servers"
  log "Run ${YELLOW}nvim -u ~/.vim/config/vscode-neovim/vscode.vim +PlugInstall +quitall${CYAN} to install vscode-neovim plugins"
  echo
}

setup_ssh_key() {
  # ssh-keygen -t rsa -b 4096 -C ""
  ssh-keygen -t ed25519 -C ""
  cat ~/.ssh/id_ed25519.pub
  log "Copy public key and add it in ${YELLOW}https://github.com/settings/keys"
}

install() {
  [ -z "$1" ] && log "No name provided, exiting.."
  for package in $@; do
    case "$package" in
      devtools )
        install_development_tools ;;
      dotfiles )
        install_dotfiles ;;
      docker )
        install_docker ;;
      java )
        install_java ;;
      python )
        install_python ;;
      node )
        install_node ;;
      tmux )
        install_tmux ;;
      neovim )
        install_neovim ;;
      ssh-key )
        setup_ssh_key ;;
      * )
        log "Unknown package $package, skipping.." ;;
    esac
  done
}

if [ -n "$1" ]; then
  command="$1"
  shift 1
  case "$command" in
    install )
      install "$@" ;;
    * )
      usage ;;
  esac
  exit
fi

log "Installing for $platform"
install_development_tools
install_dotfiles
install_java
install_python
install_node
install_tmux
install_neovim

log "\nInstalling zsh plugins.."
zsh  # auto exit makes installing binaries to fail for some reason
zsh -c "source $HOME/.zinit/plugins/zdharma---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme clean"
log "\nRun one of these commands to set default shell to zsh:"
log "${YELLOW}sudo chsh -s \$(which zsh) \$(whoami)"
log "${YELLOW}sed -i -e '1i[ -t 1 ] && exec zsh\' ~/.bashrc  ${BLACK}# run zsh when bash starts"

read -p "Set up ssh key? (y/n) " -n 1;
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  setup_ssh_key
fi

log "\nFinished, exiting.."
