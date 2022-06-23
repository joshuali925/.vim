#!/usr/bin/env bash

NODE_VERSION=14.19.1
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
  [ "$EUID" -ne 0 ] && set -- command sudo "$@"
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
  if [ -e "$1" ]; then
    mkdir -p "$BACKUP_DIR"
    # \mv -v --backup=t "$1" "$BACKUP_DIR/$(basename "$1").backup"
    \mv -v "$1" "$BACKUP_DIR/$(basename "$1").backup_$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)"
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
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh git
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    sudo apt-get update && sudo apt-get install -y build-essential zsh git curl unzip
  elif [ "$PLATFORM" == 'darwin' ]; then
    mkdir -pv ~/.local/bin
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils
    echo "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH\"" | tee -a ~/.bashrc ~/.zshrc
    echo "FPATH=\"$(brew --prefix)/share/zsh/site-functions:\$FPATH\"" >> ~/.zshrc
    brew install gnu-sed && ln -s "$(which gsed)" ~/.local/bin/sed
    brew install findutils && ln -s "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && ln -s "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar && ln -s "$(which gtar)" ~/.local/bin/tar
    brew tap homebrew/cask-fonts
    brew install font-jetbrains-mono-nerd-font
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    log "Installed homebrew and packages, exported to ~/.zshrc and ~/.bashrc"
    defaults write -g ApplePressAndHoldEnabled -bool false
    log "Disabled ApplePressAndHoldEnabled to support key repeats"
    # brew tap wez/wezterm
    # brew install --cask wez/wezterm/wezterm rectangle maccy karabiner-elements alt-tab visual-studio-code squirrel
    # manually install https://github.com/xiaogdgenuine/Doll snipaste
  fi
  log "\nInstalling asdf.."
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --depth=1
  [ -s "$HOME/.asdf/asdf.sh" ] && source "$HOME/.asdf/asdf.sh"
}

install_docker() {
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y docker
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    curl -fsSL https://get.docker.com/ | sh
  else
    echo "Unknown distro.."
    return 0
  fi
  log "Installed docker, adding user to docker group.."
  sudo groupadd docker || true
  sudo usermod -aG docker "$USER" || true
  sudo systemctl restart docker || sudo service docker restart
  sudo chmod 666 /var/run/docker.sock  # groupadd will take effect after shell re-login, enable read write access for other groups now to work immediately
  # TODO remove docker-compose when 'docker compose <Tab>' completions are working
  log "Installing docker-compose.."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  log "Installed, run ${YELLOW}docker info${CYAN} for status"
}

install_java() {  # manual install list: https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  local jdk_version=adoptopenjdk-14.0.2+12
  [ "$PLATFORM" == 'darwin' ] && [ "$ARCHITECTURE" == 'arm64' ] && jdk_version=adoptopenjdk-11.0.15+10
  asdf plugin add java || true
  asdf install java "$jdk_version"
  asdf global java "$jdk_version"
  export JAVA_HOME="$(asdf where java)"
  echo "export JAVA_HOME=\"$(asdf where java)\"" | tee -a ~/.bashrc ~/.zshrc
  log "Installed $jdk_version, exported JAVA_HOME to ~/.bashrc and ~/.zshrc, restart your shell"
}

install_python() {
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y python3-devel
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    sudo apt-get update && sudo apt-get install -y python3-dev python3-pip python3-venv
  elif [ "$PLATFORM" != 'darwin' ]; then
    echo "Unknown distro.."
    return 0
  fi
  pip3 install --user pynvim
  log "Installed pynvim, python3 and pip3"
}

install_dotfiles() {
  log "\nCloning dotfiles.."
  if [ ! -f "$HOME/.vim/config/.bashrc" ]; then
    backup "$HOME/.vim"
    git clone https://github.com/joshuali925/.vim.git "$HOME/.vim" --depth=1
  fi
  log "\nCreating directories.."
  mkdir -pv ~/.cache/{n,}vim/undo ~/.local/{bin,lib,share/lf} ~/.config/{lf,lazygit}
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
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    link_file "$HOME/.vim/config/karabiner.json" "$HOME/.config/karabiner/assets/complex_modifications/karabiner.json"
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
    return 0
  fi
  log "Installing tmux plugins.."
  backup "$HOME/.tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth=1
  ~/.tmux/plugins/tpm/bin/install_plugins || true
  if [ -e "$HOME/.tmux/plugins/tmux-thumbs" ]; then
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
  if [ ! -d "$HOME/.terminfo" ]; then
    curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src && rm terminfo.src
    log "Installed tmux-256colors terminfo to ~/.terminfo"
  fi
  echo
}

install_node() {
  log "Installing node $NODE_VERSION.."
  asdf plugin add nodejs || true
  asdf install nodejs "$NODE_VERSION"
  asdf global nodejs "$NODE_VERSION"
  log "Installing node packages.."
  mkdir -p ~/.local/lib/node-packages && pushd ~/.local/lib/node-packages
  echo '{}' >> package.json
  npm install yarn || true
  npm install eslint || true
  npm install prettier || true
  popd
  echo
}

install_neovim() {
  link_file "$HOME/.vim/config/nvim" "$HOME/.config/nvim"
  backup "$HOME/.local/lib/nvim"
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
      chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract && rm nvim.appimage
      \mv squashfs-root ~/.local/lib/nvim && ln -sf ~/.local/lib/nvim/usr/bin/nvim ~/.local/bin/nvim

      # curl -L -o- https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz -C ~/.local/lib
      # \mv ~/.local/lib/nvim-linux64 ~/.local/lib/nvim && ln -sf ~/.local/lib/nvim/bin/nvim ~/.local/bin/nvim
    else
      curl -L -o- https://github.com/joshuali925/.vim/releases/download/binaries/neovim-linux-arm64.tar.gz | tar xz -C ~/.local/lib nvim
      ln -sf ~/.local/lib/nvim/bin/nvim ~/.local/bin/nvim
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
    curl -L -o- https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz | tar xz -C ~/.local/lib
    \mv ~/.local/lib/nvim-macos ~/.local/lib/nvim
    ln -sf ~/.local/lib/nvim/bin/nvim ~/.local/bin/nvim
  else
    echo "Unknown distro.."
    return 0
  fi
  log "Installed neovim, installing plugins.."
  # TODO https://github.com/wbthomason/packer.nvim/issues/198#issuecomment-817426007
  timeout 120 ~/.local/bin/nvim --headless -u NORC --noplugin +'autocmd User PackerComplete quitall' +'silent lua require("plugins").sync()' || true
  timeout 120 ~/.local/bin/nvim --headless +'PackerLoad! nvim-treesitter' +'TSUpdateSync | quitall' || true
  timeout 30 ~/.local/bin/nvim --headless +'lua vim.defer_fn(function() vim.cmd("quitall") end, 27000)' || true
  log "\nInstalled neovim plugins, run ${YELLOW}:LspInstallAll${CYAN} in neovim to install language servers"
  log "Run ${YELLOW}nvim -u ~/.vim/config/vscode-neovim/vscode.vim +PlugInstall +quitall${CYAN} to install vscode-neovim plugins"
  echo
}

setup_ssh_key() {
  # ssh-keygen -t rsa -b 4096 -C "" -N "" -f "$HOME/.ssh/id_rsa"
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
  set -eo pipefail
  cd "$HOME"
  export PATH="$HOME/.local/bin:$PATH"
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
