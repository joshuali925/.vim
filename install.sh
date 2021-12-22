#!/usr/bin/env bash

NVM_VERSION=0.38.0
# NODE_VERSION=10.24.1
NODE_VERSION=14.17.5
DOCKER_COMPOSE_VERSION=1.29.2
BACKUP_DIR=$HOME/config-backup

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLACK="\033[1;30m"
NC='\033[0m'

detect-env() {
  case $(uname -m) in
    # mac shows i386 for x86_64
    i[36]86 | amd64 | x86_64)
      ARCHITECTURE="x86_64" ;;
    *armv6*)
      ARCHITECTURE="arm6" ;;
    *armv7*)
      ARCHITECTURE="arm7" ;;
    *aarch64* | *armv8* | arm64)
      ARCHITECTURE="arm64" ;;
    *)
      echo "architecture not supported, exiting.." >&2
      exit 1 ;;
  esac
  case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      PLATFORM=linux
      if [ -x "$(command -v yum)" ]; then
        PACKAGE_MANAGER=yum
      elif [ -x "$(command -v apt)" ]; then
        PACKAGE_MANAGER=apt
      elif [ -x "$(command -v apt-get)" ]; then
        PACKAGE_MANAGER=apt-get
      else
        PACKAGE_MANAGER=echo
        echo "package manager not supported" >&2
      fi
      ;;
    darwin*)
      PLATFORM=darwin ;;
    *)
      echo "os not supported, exiting.." >&2
      exit 1 ;;
  esac
}

sudo() {
  [[ $EUID = 0 ]] || set -- command sudo "$@"
  "$@"
}

log() {
  echo -e "${CYAN}${*}${NC}"
}

usage() {
  echo "usage: bash $0 [install <package> ...]"
  echo "  package list: devtools, dotfiles, docker, java, python, node, tmux, neovim, ssh-key"
  exit 1
}

backup() {
  if [[ -a "$1" ]]; then
    mkdir -p "$BACKUP_DIR"
    # mv -v --backup=t "$1" "$BACKUP_DIR/$(basename "$1").backup"
    mv -v "$1" "$BACKUP_DIR/$(basename "$1").backup"
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
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt' ]; then
    sudo apt update && sudo apt install -y build-essential zsh
  elif [ "$PLATFORM" == 'darwin' ]; then
    mkdir -pv ~/.local/bin
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install coreutils openssh
    echo "export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH" >> ~/.zshrc
    echo "export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH" >> ~/.bashrc
    brew install gnu-sed && ln -s "$(which gsed)" ~/.local/bin/sed
    brew install findutils && ln -s "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && ln -s "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    log "Installed homebrew and packages, exported to ~/.zshrc and ~/.bashrc"
    defaults write -g ApplePressAndHoldEnabled -bool false  # enable key repeats
    log "Disabled ApplePressAndHoldEnabled to support key repeats"
    # brew install --cask rectangle maccy karabiner-elements alt-tab visual-studio-code
    # brew tap wez/wezterm
    # brew install --cask wez/wezterm/wezterm
  fi
}

install_docker() {
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y docker
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt' ]; then
    curl -fsSL https://get.docker.com/ | sh
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed docker, adding permissions.."
  sudo groupadd docker || true
  sudo usermod -aG docker "$USER"
  sudo systemctl restart docker || sudo service docker restart
  log "Installing docker-compose.."
  sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  log "Installed, re-login and run ${YELLOW}docker info${CYAN} for status"
}

install_java() {
  # https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  # https://github.com/shyiko/jabba/blob/3bb7cca8389753072e9f6fbb9fee6fdfa85ca57f/index.json#L833
  local jdk_version jdk_url
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      jdk_url=https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz
      jdk_version=jdk-14.0.1
    else
      jdk_url=https://github.com/bell-sw/Liberica/releases/download/14.0.2+13/bellsoft-jdk14.0.2+13-linux-aarch64.tar.gz
      jdk_version=jdk-14.0.2
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      # brew tap AdoptOpenJDK/openjdk && brew install --cask adoptopenjdk14
      # echo "export JAVA_HOME=$(/usr/libexec/java_home)" >> ~/.zshrc
      # return 0
      jdk_url=https://cdn.azul.com/zulu/bin/zulu14.29.23-ca-jdk14.0.2-macosx_x64.tar.gz
      jdk_version=zulu14.29.23-ca-jdk14.0.2-macosx_x64
    else
      jdk_url=https://cdn.azul.com/zulu/bin/zulu15.36.13-ca-jdk15.0.5-macosx_aarch64.tar.gz
      jdk_version=zulu15.36.13-ca-jdk15.0.5-macosx_aarch64
    fi
  else
    echo "Unknown distro.."
    exit 1
  fi
  curl -L -o- "$jdk_url" | tar -xz -C "$HOME/.local"
  echo "export PATH=\$HOME/.local/$jdk_version/bin:\$PATH" >> ~/.zshrc
  echo "export JAVA_HOME=\$HOME/.local/$jdk_version" >> ~/.zshrc
  log "Installed $jdk_version, exported JAVA_HOME to ~/.zshrc, restart your shell"
}

install_python() {
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y python3-devel
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt' ]; then
    sudo apt update && sudo apt install -y python3-dev python3-pip python3-venv
  elif [ "$PLATFORM" != 'darwin' ]; then
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed python3 and pip3"
}

install_dotfiles() {
  log "\nCloning dotfiles.."
  backup "$HOME/.vim"
  git clone https://github.com/joshuali925/.vim.git "$HOME/.vim" --depth 1
  log "\nCreating directories.."
  mkdir -pv ~/.cache/{n,}vim/undo ~/.local/{bin,node-packages,share/lf} ~/.config/{lf,bpytop,lazygit}
  log "\nLinking configurations.."
  echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
  echo 'source ~/.vim/config/.zshrc' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  log "Appended 'source ~/.vim/config/.bashrc' to ~/.bashrc"
  log "Appended 'source ~/.vim/config/.zshrc' to ~/.zshrc"
  log "Appended 'skip_global_compinit=1' to ~/.zshenv"
  link_file "$HOME/.vim/config/.tmux.conf" "$HOME/.tmux.conf"
  link_file "$HOME/.vim/config/.gitconfig" "$HOME/.gitconfig"
  link_file "$HOME/.vim/config/lfrc" "$HOME/.config/lf/lfrc"
  link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/.config/lazygit/config.yml"
  link_file "$HOME/.vim/config/.ideavimrc" "$HOME/.ideavimrc"
  if [ "$PLATFORM" == 'darwin' ]; then
    mkdir -p ~/Library/Application\ Support/lazygit "$HOME/.config/wezterm"
    ln -sf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/Library/ApplicationSupport/lazygit/config.yml"
    link_file "$HOME/.vim/config/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
    link_file "$HOME/Library/ApplicationSupport/Code/User/snippets" "$HOME/.vsnip"  # use vscode snipets for neovim vsnip plugin
    # link_file $HOME/.zshrc $HOME/.zprofile  # link .zshrc for MacVim
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    cp ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
    log "Linked configs for MacOS"
  fi
  echo
}

install_tmux() {
  log "Installing tmux.."
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-linux-x86_64.tar.gz | tar xz -C "$HOME/.local/bin" tmux
    else
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-linux-arm64.tar.gz | tar xz -C "$HOME/.local/bin" tmux
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
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
    if [ "$PLATFORM" == 'linux' ]; then
      if [ "$ARCHITECTURE" == 'x86_64' ]; then
        curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-linux-x86_64.tar.gz | tar xz -C "$HOME/.tmux/plugins/tmux-thumbs"
      else
        curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-linux-arm64.tar.gz | tar xz -C "$HOME/.tmux/plugins/tmux-thumbs"
      fi
    elif [ "$PLATFORM" == 'darwin' ]; then
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-darwin-x86_64.tar.gz | tar xz -C "$HOME/.tmux/plugins/tmux-thumbs"
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
  node --version && ln -sf "$(which node)" ~/.local/bin/node && ln -sf "$(which npm)" ~/.local/bin/npm
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
  local tag=$(curl -s https://github.com/neovim/neovim/releases/latest | sed 's#.*tag/\(.*\)\".*#\1#')
  link_file "$HOME/.vim/config/nvim" "$HOME/.config/nvim"
  backup "$HOME/.local/nvim"
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      curl -LO "https://github.com/neovim/neovim/releases/download/$tag/nvim.appimage"
      chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract && rm nvim.appimage
      mv squashfs-root ~/.local/nvim && ln -sf ~/.local/nvim/usr/bin/nvim ~/.local/bin/nvim

      # curl -L -o- https://github.com/neovim/neovim/releases/download/$tag/nvim-linux64.tar.gz | tar xz -C ~/.local
      # mv ~/.local/nvim-linux64 ~/.local/nvim
      # ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
    else
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/neovim-linux-arm64.tar.gz | tar xz -C ~/.local nvim
      ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
    curl -L -o- "https://github.com/neovim/neovim/releases/download/$tag/nvim-macos.tar.gz" | tar xz -C ~/.local
    mv ~/.local/nvim-osx64 ~/.local/nvim
    ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
  else
    echo "Unknown distro.."
    exit 1
  fi
  log "Installed neovim, installing plugins.."
  # https://github.com/wbthomason/packer.nvim/issues/198#issuecomment-817426007
  sh -c 'sleep 120 && pkill nvim && echo "Timeout, killed neovim"' &
  local pid=$!
  ~/.local/bin/nvim --headless -u NORC --noplugin +"autocmd User PackerComplete quitall" +"silent lua require('plugins').sync()" || true
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
  ssh-keygen -t ed25519 -C "" -N "" -f "$HOME/.ssh/id_ed25519"
  cat ~/.ssh/id_ed25519.pub
  log "Copy public key and add it in ${YELLOW}https://github.com/settings/keys"
}

install() {
  shift 1
  [ -z "$1" ] && usage
  init
  for package in "$@"; do
    case $package in
      devtools)   install_development_tools ;;
      dotfiles)   install_dotfiles ;;
      docker)     install_docker ;;
      java)       install_java ;;
      python)     install_python ;;
      node)       install_node ;;
      tmux)       install_tmux ;;
      neovim)     install_neovim ;;
      ssh-key)    setup_ssh_key ;;
      *)          log "Unknown package \"$package\", skipping.." ;;
    esac
  done
}

init() {
  set -e
  cd "$HOME"
  detect-env
}

default-install() {
  init
  log "Installing for $PLATFORM"
  install_development_tools
  install_dotfiles
  install_java
  install_python
  install_node
  install_tmux
  install_neovim

  log "\nInstalling zsh plugins.."
  zsh  # auto exit makes installing binaries to fail for some reason

  setup_ssh_key
  log "\nRun one of these commands to set default shell to zsh:"
  log "${YELLOW}"'sudo chsh -s $(which zsh) $(whoami)'
  log "${YELLOW}sed -i -e '1i[ -t 1 ] && exec zsh\' ~/.bashrc  ${BLACK}# run zsh when bash starts"
  log "${YELLOW}sudo vim /etc/passwd"

  log "\nFinished, exiting.."
}

case $1 in
  '')         default-install ;;
  install)    install "$@" ;;
  detect-env) detect-env ;;
  *)          usage ;;
esac
