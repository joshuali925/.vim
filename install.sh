#!/usr/bin/env bash
# shellcheck disable=1090,2015,2155

NODE_VERSION=18.19.0
JDK_VERSION=21
BACKUP_DIR=$HOME/config-backup

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLACK='\033[1;30m'
NC='\033[0m'

usage() {
  echo "usage: bash $0 [install <package> ...]" >&2
  compgen -A function | awk '/^install_/ { sub(/^install_/, ""); if (length(output) == 0) output = $0; else output = output ", " $0 } END { print "  packages list: " output }' >&2
  exit 1
}

init() {
  [[ -n $INSTALL_ENV_INIT ]] && return 0 || INSTALL_ENV_INIT=1
  set -eo pipefail
  cd
  export PATH="$HOME/.local/bin:$PATH:$HOME/.vim/bin"
  detect-env
}

install() {
  [[ $# -eq 0 ]] && usage
  init
  for package in "$@"; do
    if declare -F "install_$package" > /dev/null; then
      "install_$package"
    elif declare -F "install_${package%%-*}" > /dev/null; then
      "install_${package%%-*}" "${package##*-}"  # `$0 install swap-8` would install swap of 8G
    else
      log "Unknown package \"$package\", skipping.."
    fi
  done
}

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
      if [[ -x $(command -v yum) ]]; then
        PACKAGE_MANAGER=yum
      elif [[ -x $(command -v apt-get) ]]; then
        PACKAGE_MANAGER=apt-get
      elif [[ -x $(command -v apk) ]]; then
        PACKAGE_MANAGER=apk
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
  [[ $EUID -ne 0 ]] && set -- command sudo "$@"
  "$@"
}

log() {
  echo -e "${CYAN}${*}${NC}" >&2
}

backup() {
  for arg in "$@"; do
    if [[ -e $arg ]] || [[ -L $arg ]]; then  # -L is needed for broken symlinks
      mkdir -p "$BACKUP_DIR"
      mv -v "$arg" "$BACKUP_DIR/$(basename "$arg").backup_$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)"  # .backup_$(date +%s) suffix won't be unique in this script
    fi
  done
}

link_file() {
  local sourceFile="$1" destFile="$2"
  backup "$destFile"
  shift 2
  ln -s "$@" "$sourceFile" "$destFile" || ln -s "$sourceFile" "$destFile"
  log "Linked $sourceFile to $destFile"
}

install_devtools() {
  log '\nInstalling development tools..'
  if [[ $OSTYPE = linux-android ]]; then
    pkg upgrade -y -o DPkg::Options::='--force-confnew' && apt update && apt upgrade -y && pkg install -y zsh openssh wget git vim termux-exec diffutils fd ripgrep yazi lazygit tmux bat git-delta neovim
    chsh -s zsh "$(whoami)"
    mkdir -p ~/temp && cd ~/temp
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip && unzip JetBrainsMono.zip
    mv JetBrainsMonoNLNerdFontMono-Regular.ttf ~/.termux/font.ttf
    git clone https://github.com/adi1090x/termux-style --depth=1 && cd termux-style && ./install && cd ~
    rm -rf ~/temp
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:yum ]]; then
    sudo yum groupinstall -y 'Development Tools' && sudo yum install -y zsh git vim
    sudo yum install -y epel-release || true
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apt-get ]]; then
    sudo apt-get update && sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential zsh git curl unzip
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apk ]]; then
    sudo apk add bash zsh git curl alpine-sdk
  elif [[ $PLATFORM = darwin ]]; then
    mkdir -pv ~/.local/bin
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils wget
    echo -e "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH\"" | tee -a ~/.bashrc ~/.zshrc
    brew install grep && link_file "$(which ggrep)" ~/.local/bin/grep
    brew install gnu-sed && link_file "$(which gsed)" ~/.local/bin/sed
    brew install findutils && link_file "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && link_file "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar && link_file "$(which gtar)" ~/.local/bin/tar
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    sed -i -e "1iFPATH=\"$(brew --prefix)/share/zsh/site-functions:\$FPATH\"" ~/.zshrc
    log 'Installed homebrew and packages, exported to ~/.zshrc and ~/.bashrc'
    defaults write -g com.apple.swipescrolldirection -bool false
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write -g NSAutomaticCapitalizationEnabled -bool false
    log 'Updated mac settings'  # https://sxyz.blog/macos-setup/
    # git clone https://github.com/iDvel/rime-ice ~/Library/Rime --depth=1  # open rime from /Library/Input Methods/Squirrel.app
    # sed -i 's/\(Shift_[LR]: \)noop/\1commit_code/' ~/Library/Rime/default.yaml  # https://github.com/iDvel/rime-ice/pull/129
    # brew install --cask font-jetbrains-mono-nerd-font wezterm rectangle linearmouse maccy pixpin trex jordanbaird-ice doll karabiner-elements alt-tab squirrel darkmodebuddy coconutbattery visual-studio-code orion
    # tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo && tic -x -o ~/.terminfo $tempfile && rm $tempfile
    # to update wezterm: brew upgrade --cask wezterm --no-quarantine --greedy-latest
  fi
}

install_dotfiles() {
  log 'Cloning dotfiles..'
  if [[ ! -f ~/.vim/config/.bashrc ]]; then
    backup ~/.vim
    git clone --filter=blob:none https://github.com/joshuali925/.vim.git ~/.vim
  fi
  log 'Creating directories..'
  mkdir -pv ~/.local/{bin,lib,share} ~/.config/lazygit ~/.ssh ~/projects
  log 'Linking configurations..'
  echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
  echo 'source ~/.vim/config/zsh/.zshrc' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  log "Appended 'source ~/.vim/config/.bashrc' to ~/.bashrc"
  log "Appended 'source ~/.vim/config/zsh/.zshrc' to ~/.zshrc"
  log "Appended 'skip_global_compinit=1' to ~/.zshenv"
  echo 'Include ~/.vim/config/ssh_config' >> ~/.ssh/config
  echo 'Include ~/.ssh/ec2hosts' >> ~/.ssh/config
  link_file ~/.vim/config/.tmux.conf ~/.tmux.conf --relative
  link_file ~/.vim/config/.gitconfig ~/.gitconfig --relative
  link_file ~/.vim/config/.ideavimrc ~/.ideavimrc --relative
  link_file ~/.vim/config/yazi ~/.config/yazi
  link_file ~/.vim/config/lazygit_config.yml ~/.config/lazygit/config.yml
  if [[ $PLATFORM = darwin ]]; then
    mkdir -p ~/Library/Application\ Support/lazygit ~/.config/wezterm ~/.config/karabiner/assets/complex_modifications
    ln -srf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link_file ~/.vim/config/lazygit_config.yml ~/Library/ApplicationSupport/lazygit/config.yml
    link_file ~/.vim/config/wezterm.lua ~/.config/wezterm/wezterm.lua
    link_file ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
  elif [[ $OSTYPE = linux-android ]]; then
    cat >> ~/.zshrc <<EOF
export SSH_CLIENT=1 TMUX_NO_TPM=1
export EDITOR=vim

bindkey '\ej' down-line-or-beginning-search
bindkey '\ek' up-line-or-beginning-search
bindkey '\el' forward-char
bindkey '\e;' beginning-of-line
bindkey "\e'" end-of-line
bindkey '\eu' undo
EOF
  fi
  log 'Installed dotfiles'
}

install_docker() {
  log "Installing docker.."
  if [[ $PLATFORM:$PACKAGE_MANAGER = linux:yum ]]; then
    sudo yum install -y docker
  elif [[ $PLATFORM = linux ]]; then
    curl -fsSL https://get.docker.com/ | sh
  else
    log 'Unsupported platform..'
    return 1
  fi
  log 'Adding user to docker group..'
  sudo groupadd docker || true
  sudo usermod -aG docker "$USER"
  sudo systemctl restart docker
  newgrp docker  # make group take effect immediately without re-login
  docker completion zsh > ~/.vim/config/zsh/completions/_docker
  log 'Installed docker'
}

install_java() {  # JDK list: https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  log "Installing java $JDK_VERSION.."
  mise use -g "java@$JDK_VERSION"
  export JAVA_HOME="$(mise where java)"
  echo "export JAVA_HOME=\"$JAVA_HOME\"" | tee -a ~/.bashrc ~/.zshrc
  log "Installed $JDK_VERSION, exported JAVA_HOME to ~/.bashrc and ~/.zshrc, restart your shell"
}

install_python() {  # environment for install from source: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  log "Installing python.."
  if [[ $PLATFORM:$PACKAGE_MANAGER = linux:yum ]]; then
    sudo yum install -y python3-devel
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apt-get ]]; then
    sudo apt-get update && sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y python3-dev python3-venv python3-pip
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apk ]]; then
    sudo apk add python3
  elif [[ $PLATFORM != darwin ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  if ! builtin command -v pip3 > /dev/null 2>&1; then curl https://bootstrap.pypa.io/get-pip.py | python3; fi
  log 'Installed python3, pip3'
}

install_node() {
  log "Installing node $NODE_VERSION.."
  mise use -g "nodejs@$NODE_VERSION"
  mise x -- npm config set prefix ~/.local/lib/node-packages
  log 'Installing node packages..'
  mise x -- npm install -g --cache ~/.local/lib/npm-temp-cache yarn || true
  rm -rf ~/.local/lib/npm-temp-cache
  curl -L https://raw.githubusercontent.com/zsh-users/zsh-completions/HEAD/src/_yarn -o ~/.vim/config/zsh/completions/_yarn
  log 'Installed node'
}

install_tmux() {
  log 'Installing tmux..'
  backup ~/.local/bin/tmux
  tmux -V
  log 'Installing tmux plugins..'
  if [[ ! -d ~/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth=1
  else
    ~/.tmux/plugins/tpm/bin/update_plugins all || true
  fi
  ~/.tmux/plugins/tpm/bin/install_plugins || true
  if [[ ! -d ~/.terminfo ]]; then
    curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src && rm terminfo.src
    log 'Installed tmux-256colors terminfo to ~/.terminfo'
  fi
  log 'Installed tmux and plugins'
}

install_neovim() {
  log "Installing neovim.."
  link_file ~/.vim/config/nvim ~/.config/nvim
  backup ~/.local/lib/nvim ~/.local/bin/nvim
  ~/.vim/bin/nvim --version
  timeout 120 ~/.local/bin/nvim --headless +'Lazy! restore' +quitall || true
  if [[ $PLATFORM = darwin ]]; then
    nvim -u ~/.vim/config/vscode-neovim/vscode.vim -i NONE +PlugInstall +quitall
  fi
  log "\nInstalled neovim and plugins"
}

install_swap() {
  if [[ $PLATFORM != linux ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  local g="${1:-4}"
  log "Installing ${g}G swapfile.."
  sudo dd if=/dev/zero of=/swapfile count=$((g * 1024)) bs=1MiB && sudo chmod 600 /swapfile
  sudo mkswap /swapfile && sudo swapon /swapfile
  sudo sed -i '/^\/swapfile swap swap defaults 0 0$/d' /etc/fstab
  echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab
  free -h
}

install_pm2() {
  if [[ $PLATFORM != linux ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  npm install -g pm2
  pm2 set pm2:autodump true
  sudo -E "$(mise which node)" "$(which pm2)" startup systemd -u "$USER" --hp "$HOME"
}

install_ssh-key() {
  if [[ -f ~/.ssh/id_ed25519 ]]; then  # shellcheck disable=2088
    log '~/.ssh/id_ed25519 already exists, skipping..'
    return 0
  fi
  ssh-keygen -t ed25519 -C '' -N '' -f ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub
  log "Copy public key and add it in ${YELLOW}https://github.com/settings/keys"
}

default-install() {
  log "Installing for $OSTYPE"
  install devtools dotfiles

  log 'Installing zsh plugins..'
  zsh -ic 'exit' &

  if [[ $OSTYPE = linux-android ]]; then
    wait
    log 'Finished package installs for termux. Setting up file access and styles (use dark monokai or dracula)'
    termux-setup-storage && termux-style && cp --preserve=links -r ~/storage/downloads ~/downloads
  else
    install node &
    install tmux &
    install neovim || true
    wait
  fi

  install ssh-key

  sudo chsh -s "$(which zsh)" "$(whoami)" || true
  log '\nDefault shell will be zsh after re-login, try the following if it did not work'
  log "${YELLOW}SHELL=$(which zsh) exec zsh  ${BLACK}# run zsh now"
  log "${YELLOW}sed -i -e '1i[[ -t 1 ]] && exec zsh\' ~/.bashrc  ${BLACK}# run zsh when bash starts"
  log "${YELLOW}sudo vipw  ${BLACK}# then edit login shell for user"

  log '\nFinished, exiting..'
}

case $1 in
  '')         default-install ;;
  install)    "$@" ;;
  detect-env) detect-env ;;
  *)          usage ;;
esac
