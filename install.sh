#!/usr/bin/env bash

NODE_VERSION=14.20.0
BACKUP_DIR=$HOME/config-backup

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLACK='\033[1;30m'
NC='\033[0m'

detect-env() {
  case $(uname -m) in
    # mac shows i386 for x86_64
    i[36]86 | amd64 | x86_64)
      ARCHITECTURE=x86_64 ;;
    # *armv6*)
    #   ARCHITECTURE=arm6 ;;
    # *armv7*)
    #   ARCHITECTURE=arm7 ;;
    *aarch64* | *armv8* | arm64)
      ARCHITECTURE=arm64 ;;
    *)
      echo 'architecture not supported, exiting..' >&2
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
        echo 'package manager not supported' >&2
      fi
      ;;
    darwin*)
      PLATFORM=darwin ;;
    *)
      echo 'os not supported, exiting..' >&2
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
  echo '  package list: devtools, dotfiles, docker, java, python, node, tmux, neovim, ssh-key'
  exit 1
}

backup() {
  if [ -e "$1" ]; then
    mkdir -p "$BACKUP_DIR"
    \mv -v "$1" "$BACKUP_DIR/$(basename "$1").backup_$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)"  # .backup_$(date +%s) suffix won't be unique in this script
  fi
}

link_file() {
  local sourceFile="$1" destFile="$2"
  backup "$destFile"
  shift 2
  ln -s "$@" "$sourceFile" "$destFile"
  log "Linked $sourceFile to $destFile"
}

install_asdf() {
  if [ ! -s "$HOME/.asdf/asdf.sh" ]; then
    log '\nInstalling asdf..'
    echo 'legacy_version_file = yes' > ~/.asdfrc
    git clone https://github.com/asdf-vm/asdf.git --depth=1 ~/.asdf
    source ~/.asdf/asdf.sh
  fi
}

install_development_tools() {
  log '\nInstalling development tools..'
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh git
    sudo yum install -y epel-release || true
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential zsh git curl unzip
  elif [ "$PLATFORM" == 'darwin' ]; then
    mkdir -pv ~/.local/bin
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils
    echo -e "export HOMEBREW_NO_AUTO_UPDATE=1\nexport PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH\"" | tee -a ~/.bashrc ~/.zshrc
    echo "FPATH=\"$(brew --prefix)/share/zsh/site-functions:\$FPATH\"" >> ~/.zshrc
    brew install grep && ln -s "$(which ggrep)" ~/.local/bin/grep
    brew install gnu-sed && ln -s "$(which gsed)" ~/.local/bin/sed
    brew install findutils && ln -s "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && ln -s "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar && ln -s "$(which gtar)" ~/.local/bin/tar
    brew tap homebrew/cask-fonts
    brew install font-jetbrains-mono-nerd-font
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    log 'Installed homebrew and packages, exported to ~/.zshrc and ~/.bashrc'
    defaults write -g ApplePressAndHoldEnabled -bool false
    log 'Disabled ApplePressAndHoldEnabled to support key repeats'
    # brew tap wez/wezterm
    # brew install --cask wez/wezterm/wezterm rectangle maccy karabiner-elements alt-tab visual-studio-code squirrel
    # manually install:
    # Doll: https://github.com/xiaogdgenuine/Doll
    # snipaste: https://www.snipaste.com/download.html
    # mousefix: https://mousefix.org
    # Orion: https://browser.kagi.com
    # coconutBattery: https://www.coconut-flavour.com/coconutbattery
  fi
  install_asdf
}

install_dotfiles() {
  log '\nCloning dotfiles..'
  if [ ! -f "$HOME/.vim/config/.bashrc" ]; then
    backup "$HOME/.vim"
    git clone https://github.com/joshuali925/.vim.git "$HOME/.vim" --depth=1
  fi
  log '\nCreating directories..'
  mkdir -pv ~/.cache/{n,}vim/undo ~/.local/{bin,lib,share/lf} ~/.config/{lf,lazygit}
  log '\nLinking configurations..'
  echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
  echo 'source ~/.vim/config/.zshrc' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  log "Appended 'source ~/.vim/config/.bashrc' to ~/.bashrc"
  log "Appended 'source ~/.vim/config/.zshrc' to ~/.zshrc"
  log "Appended 'skip_global_compinit=1' to ~/.zshenv"
  link_file "$HOME/.vim/config/.tmux.conf" "$HOME/.tmux.conf" --relative
  link_file "$HOME/.vim/config/.gitconfig" "$HOME/.gitconfig" --relative
  link_file "$HOME/.vim/config/.ideavimrc" "$HOME/.ideavimrc" --relative
  link_file "$HOME/.vim/config/lfrc" "$HOME/.config/lf/lfrc"
  link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/.config/lazygit/config.yml"
  if [ "$PLATFORM" == 'darwin' ]; then
    mkdir -p ~/Library/Application\ Support/lazygit "$HOME/.config/wezterm"
    ln -srf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/Library/ApplicationSupport/lazygit/config.yml"
    link_file "$HOME/.vim/config/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    link_file "$HOME/.vim/config/karabiner.json" "$HOME/.config/karabiner/assets/complex_modifications/karabiner.json"
    log 'Linked configs for MacOS'
  fi
  echo
}

install_docker() {
  log "Installing docker.."
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y docker
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    curl -fsSL https://get.docker.com/ | sh
  else
    echo 'Unknown distro..'
    return 0
  fi
  log 'Installed docker, adding user to docker group..'
  sudo groupadd docker || true
  sudo usermod -aG docker "$USER" || true
  sudo systemctl restart docker || sudo service docker restart
  sudo chmod 666 /var/run/docker.sock  # groupadd will take effect after shell re-login, enable read write access for other groups now to work immediately
  # TODO https://github.com/docker/compose/issues/8550, remove docker-compose and its zsh completion when 'docker compose <Tab>' completions are working
  log 'Installing docker-compose..'
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  log "Installed, run ${YELLOW}docker info${CYAN} for status"
}

install_java() {  # JDK list: https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  install_asdf
  local jdk_version=adoptopenjdk-14.0.2+12
  [ "$PLATFORM" == 'darwin' ] && [ "$ARCHITECTURE" == 'arm64' ] && jdk_version=adoptopenjdk-11.0.15+10
  log "Installing java $jdk_version.."
  asdf plugin add java || true
  asdf install java "$jdk_version"
  asdf global java "$jdk_version"
  export JAVA_HOME="$(asdf where java)"
  echo "export JAVA_HOME=\"$(asdf where java)\"" | tee -a ~/.bashrc ~/.zshrc
  log "Installed $jdk_version, exported JAVA_HOME to ~/.bashrc and ~/.zshrc, restart your shell"
}

install_python() {  # environment for asdf install from source: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  log "Installing python.."
  if [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:yum' ]; then
    sudo yum install -y python3-devel
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
  elif [ "$PLATFORM:$PACKAGE_MANAGER" == 'linux:apt-get' ]; then
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-dev python3-pip python3-venv
  elif [ "$PLATFORM" != 'darwin' ]; then
    echo 'Unknown distro..'
    return 0
  fi
  pip3 install --user pynvim
  log 'Installed python3, pip3, pynvim'
  log "To use pynvim regardless of venv, set ${YELLOW}vim.g.python3_host_prog = \"$(which python3)\""
}

install_node() {
  install_asdf
  log "Installing node $NODE_VERSION.."
  asdf plugin add nodejs || true
  asdf install nodejs "$NODE_VERSION"
  asdf global nodejs "$NODE_VERSION"
  log 'Installing node packages..'
  mkdir -p ~/.local/lib/node-packages && pushd ~/.local/lib/node-packages
  [ ! -f package.json ] && echo '{}' >> package.json
  npm install --cache npm-temp-cache yarn || true
  rm -rf npm-temp-cache
  popd
  echo
}

install_tmux() {
  log 'Installing tmux..'
  backup "$HOME/.local/bin/tmux"
  tmux -V
  if [ ! -d "$HOME/.tmux" ]; then
    log 'Installing tmux plugins..'
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth=1
    ~/.tmux/plugins/tpm/bin/install_plugins || true
    if [ -d "$HOME/.tmux/plugins/tmux-thumbs" ]; then
      log 'Installing tmux-thumbs binaries..'
      curl -L -o- "https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-$PLATFORM-$ARCHITECTURE.tar.gz" | tar xz -C "$HOME/.tmux/plugins/tmux-thumbs"
    fi
  else
    log '~/.tmux directory exists, updating tmux plugins..'
    ~/.tmux/plugins/tpm/bin/update_plugins all || true
  fi
  if [ ! -d "$HOME/.terminfo" ]; then
    curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src && rm terminfo.src
    log 'Installed tmux-256colors terminfo to ~/.terminfo'
  fi
  echo
}

install_neovim() {
  log "Installing neovim.."
  link_file "$HOME/.vim/config/nvim" "$HOME/.config/nvim"
  backup "$HOME/.local/lib/nvim"
  nvim --version
  log 'Installed neovim, installing plugins..'
  timeout 120 ~/.local/bin/nvim --headless -u NORC --noplugin +'autocmd User PackerComplete quitall' +'silent lua require("plugins").compile()' || true
  timeout 30 ~/.local/bin/nvim --headless +'lua vim.defer_fn(function() vim.cmd.quitall() end, 27000)' || true
  log "\nInstalled neovim plugins, run ${YELLOW}nvim -u ~/.vim/config/vscode-neovim/vscode.vim -i NONE +PlugInstall +quitall${CYAN} to install vscode-neovim plugins"
  echo
}

setup_ssh_key() {
  # ssh-keygen -t rsa -b 4096 -C '' -N '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub
  ssh-keygen -t ed25519 -C '' -N '' -f ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub
  log "Copy public key and add it in ${YELLOW}https://github.com/settings/keys"
}

install() {
  [ "$#" -eq 0 ] && usage
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
  [ -n "$INSTALL_ENV_INIT" ] && return 0 || INSTALL_ENV_INIT=1
  set -eo pipefail
  cd "$HOME"
  export PATH="$HOME/.local/bin:$PATH:$HOME/.vim/bin"
  detect-env
}

default-install() {
  log "Installing for $OSTYPE"
  install devtools dotfiles java python node tmux neovim

  log '\nInstalling zsh plugins..'
  zsh -ic 'exit'

  install ssh-key

  sudo chsh -s "$(which zsh)" "$(whoami)" || true
  log '\nChanged default shell to zsh, try the following if it did not work'
  log "${YELLOW}sed -i -e '1i[ -t 1 ] && exec zsh\' ~/.bashrc  ${BLACK}# run zsh when bash starts"
  log "${YELLOW}sudo vipw  ${BLACK}# then edit login shell for user"

  log '\nFinished, exiting..'
}

case $1 in
  '')         default-install ;;
  install)    shift 1; install "$@" ;;
  detect-env) detect-env ;;
  *)          usage ;;
esac
