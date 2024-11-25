#!/usr/bin/env bash
# shellcheck disable=1090,2015,2155

NODE_VERSION=18.19.0
JDK_VERSION=adoptopenjdk-17.0.7+7
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
      "install_${package%%-*}" "${package##*-}"
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
  if [[ -e $1 ]] || [[ -L $1 ]]; then
    mkdir -p "$BACKUP_DIR"
    \mv -v "$1" "$BACKUP_DIR/$(basename "$1").backup_$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)"  # .backup_$(date +%s) suffix won't be unique in this script
  fi
}

link_file() {
  local sourceFile="$1" destFile="$2"
  backup "$destFile"
  shift 2
  ln -s "$@" "$sourceFile" "$destFile" || ln -s "$sourceFile" "$destFile"
  log "Linked $sourceFile to $destFile"
}

install_asdf() {
  if [[ ! -s $HOME/.asdf/asdf.sh ]]; then
    log '\nInstalling asdf..'
    echo 'legacy_version_file = yes' > ~/.asdfrc
    git clone https://github.com/asdf-vm/asdf.git --depth=1 ~/.asdf
    source ~/.asdf/asdf.sh
    link_file ~/.asdf/completions/_asdf ~/.vim/config/zsh/completions/_asdf || true
  fi
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
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential zsh git curl unzip
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apk ]]; then
    sudo apk add bash zsh git curl alpine-sdk
  elif [[ $PLATFORM = darwin ]]; then
    mkdir -pv ~/.local/bin
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils
    echo -e "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH\"" | tee -a ~/.bashrc ~/.zshrc
    brew install grep && link_file "$(which ggrep)" ~/.local/bin/grep
    brew install gnu-sed && link_file "$(which gsed)" ~/.local/bin/sed
    brew install findutils && link_file "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && link_file "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar && link_file "$(which gtar)" ~/.local/bin/tar
    brew install wget
    brew install bat shellcheck
    brew tap homebrew/cask-fonts
    brew install font-jetbrains-mono-nerd-font
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
    # brew install --cask wezterm rectangle linearmouse maccy snipaste trex karabiner-elements alt-tab visual-studio-code squirrel microsoft-remote-desktop
    # tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo && tic -x -o ~/.terminfo $tempfile && rm $tempfile
    # manually install:
    # Doll: https://github.com/xiaogdgenuine/Doll
    # Orion: https://browser.kagi.com
    # coconutBattery: https://www.coconut-flavour.com/coconutbattery
    # DarkModeBuddy: https://github.com/insidegui/DarkModeBuddy
    # update wezterm: brew upgrade --cask wezterm --no-quarantine --greedy-latest
  fi
  install_asdf
}

install_dotfiles() {
  log '\nCloning dotfiles..'
  if [[ ! -f $HOME/.vim/config/.bashrc ]]; then
    backup "$HOME/.vim"
    git clone --filter=blob:none https://github.com/joshuali925/.vim.git "$HOME/.vim"
  fi
  log '\nCreating directories..'
  mkdir -pv ~/.local/{bin,lib,share} ~/.config/lazygit ~/.ssh
  log '\nLinking configurations..'
  echo 'source ~/.vim/config/.bashrc' >> ~/.bashrc
  echo 'source ~/.vim/config/zsh/.zshrc' >> ~/.zshrc
  echo 'skip_global_compinit=1' >> ~/.zshenv
  log "Appended 'source ~/.vim/config/.bashrc' to ~/.bashrc"
  log "Appended 'source ~/.vim/config/zsh/.zshrc' to ~/.zshrc"
  log "Appended 'skip_global_compinit=1' to ~/.zshenv"
  echo 'Include ~/.vim/config/ssh_config' >> ~/.ssh/config
  echo 'Include ~/.ssh/ec2hosts' >> ~/.ssh/config
  link_file "$HOME/.vim/config/.tmux.conf" "$HOME/.tmux.conf" --relative
  link_file "$HOME/.vim/config/.gitconfig" "$HOME/.gitconfig" --relative
  link_file "$HOME/.vim/config/.ideavimrc" "$HOME/.ideavimrc" --relative
  link_file "$HOME/.vim/config/yazi" "$HOME/.config/yazi"
  link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/.config/lazygit/config.yml"
  if [[ $PLATFORM = darwin ]]; then
    mkdir -p ~/Library/Application\ Support/lazygit "$HOME/.config/wezterm"
    ln -srf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link_file "$HOME/.vim/config/lazygit_config.yml" "$HOME/Library/ApplicationSupport/lazygit/config.yml"
    link_file "$HOME/.vim/config/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    link_file "$HOME/.vim/config/karabiner.json" "$HOME/.config/karabiner/assets/complex_modifications/karabiner.json"
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
  log
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
  sudo usermod -aG docker "$USER" || true
  sudo systemctl restart docker || sudo service docker restart
  sudo chmod 666 /var/run/docker.sock  # groupadd will take effect after shell re-login, enable read write access for other groups now to work immediately
  # TODO https://github.com/docker/docs/issues/16397, docker completion zsh > ~/.vim/config/zsh/completions/_docker does not have argument descriptions
  curl -fsSL -o ~/.vim/config/zsh/completions/_docker https://raw.githubusercontent.com/docker/cli/HEAD/contrib/completion/zsh/_docker || true
  log "Installed docker, run ${YELLOW}docker info${CYAN} for status"
}

install_java() {  # JDK list: https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  install_asdf
  log "Installing java $JDK_VERSION.."
  asdf plugin add java || true
  asdf install java "$JDK_VERSION"
  asdf global java "$JDK_VERSION"
  export JAVA_HOME="$(asdf where java)"
  echo "export JAVA_HOME=\"$JAVA_HOME\"" | tee -a ~/.bashrc ~/.zshrc
  log "Installed $JDK_VERSION, exported JAVA_HOME to ~/.bashrc and ~/.zshrc, restart your shell"
}

install_python() {  # environment for asdf install from source: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  log "Installing python.."
  if [[ $PLATFORM:$PACKAGE_MANAGER = linux:yum ]]; then
    sudo yum install -y python3-devel
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apt-get ]]; then
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-dev python3-venv python3-pip
  elif [[ $PLATFORM:$PACKAGE_MANAGER = linux:apk ]]; then
    sudo apk add python3
  elif [[ $PLATFORM != darwin ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  if ! builtin command -v pip3 > /dev/null 2>&1; then curl https://bootstrap.pypa.io/get-pip.py | python3; fi
  PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install --user pynvim && log 'Installed python3, pip3, pynvim' || log 'Installed python3, failed to install pip packages'
  log "To use pynvim regardless of venv, set ${YELLOW}vim.g.python3_host_prog = \"$(which python3)\""
}

install_node() {
  install_asdf
  log "Installing node $NODE_VERSION.."
  asdf plugin add nodejs || true
  asdf install nodejs "$NODE_VERSION"
  asdf global nodejs "$NODE_VERSION"
  log 'Installing node packages..'
  mkdir -p ~/.local/lib/node-packages
  [[ ! -f $HOME/.local/lib/node-packages/package.json ]] && echo '{}' >> "$HOME/.local/lib/node-packages/package.json"
  npm install --cache "$HOME/.local/lib/node-packages/npm-temp-cache" --prefix "$HOME/.local/lib/node-packages" yarn || true
  rm -rf "$HOME/.local/lib/node-packages/npm-temp-cache"
  log
}

install_tmux() {
  log 'Installing tmux..'
  backup "$HOME/.local/bin/tmux"
  tmux -V
  log 'Installing tmux plugins..'
  if [[ ! -d $HOME/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth=1
  else
    ~/.tmux/plugins/tpm/bin/update_plugins all || true
  fi
  ~/.tmux/plugins/tpm/bin/install_plugins || true
  if [[ ! -d $HOME/.terminfo ]]; then
    curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src && rm terminfo.src
    log 'Installed tmux-256colors terminfo to ~/.terminfo'
  fi
  log
}

install_neovim() {
  log "Installing neovim.."
  link_file "$HOME/.vim/config/nvim" "$HOME/.config/nvim"
  backup "$HOME/.local/lib/nvim"
  backup "$HOME/.local/bin/nvim"
  ~/.vim/bin/nvim --version
  log 'Installed neovim, installing plugins..'
  timeout 120 ~/.local/bin/nvim --headless +'Lazy! restore' +quitall || true
  timeout 30 ~/.local/bin/nvim --headless +'lua vim.defer_fn(function() vim.cmd.quitall() end, 27000)' || true
  if [[ $PLATFORM = darwin ]]; then
    nvim -u ~/.vim/config/vscode-neovim/vscode.vim -i NONE +PlugInstall +quitall
  fi
  log "\nInstalled neovim plugins"
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
  npm --prefix ~/.local/lib/node-packages install pm2
  pm2 set pm2:autodump true
  sudo -E "$(asdf which node)" "$(which pm2)" startup systemd -u "$USER" --hp "$HOME"
}

install_ssh-key() {
  ssh-keygen -t ed25519 -C '' -N '' -f ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub
  log "Copy public key and add it in ${YELLOW}https://github.com/settings/keys"
}

default-install() {
  log "Installing for $OSTYPE"
  install devtools dotfiles

  if [[ $OSTYPE = linux-android ]]; then
    log 'Finished package installs for termux. Setting up file access and styles (use dark monokai or dracula)'
    termux-setup-storage && termux-style && cp --preserve=links -r ~/storage/downloads ~/downloads
  else
    install java python node tmux neovim || true
  fi

  log '\nInstalling zsh plugins..'
  zsh -ic 'exit'

  install ssh-key

  sudo chsh -s "$(which zsh)" "$(whoami)" || true
  log '\nChanged default shell to zsh, try the following if it did not work'
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
