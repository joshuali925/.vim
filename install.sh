#!/usr/bin/env bash
# shellcheck disable=2155

NODE_VERSION=22.22.0
YARN_VERSION=1.22.10
JDK_VERSION=25
BACKUP_DIR=$HOME/config-backup

CYAN=$'\033[0;36m'
YELLOW=$'\033[0;33m'
BLACK=$'\033[1;30m'
NC=$'\033[0m'

usage() {
  echo "usage: bash $0 [install <package> ...]" >&2
  compgen -A function | awk '/^install-/ { sub(/^install-/, ""); if (length(output) == 0) output = $0; else output = output ", " $0 } END { print "  packages list: " output }' >&2
  exit 1
}

init() {
  [[ -n $INSTALL_ENV_INIT ]] && return 0 || INSTALL_ENV_INIT=1
  set -euo pipefail
  cd
  export PATH="$HOME/.local/bin:$PATH:$HOME/.vim/bin"
  detect-env
}

install() {
  [[ $# -eq 0 ]] && usage
  init
  for package in "$@"; do
    if declare -F "install-$package" > /dev/null; then
      "install-$package"
    elif declare -F "install-${package%-*}" > /dev/null; then
      "install-${package%-*}" "${package##*-}"  # `$0 install swap-8` would install swap of 8G
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
      fi ;;
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

append-once() {
  for file in "${@:2}"; do grep -qxF "$1" "$file" 2> /dev/null || echo "$1" >> "$file"; done
}

backup() {
  for arg in "$@"; do
    if [[ -e $arg ]] || [[ -L $arg ]]; then  # -L is needed for broken symlinks
      mkdir -p "$BACKUP_DIR"
      mv -v "$arg" "$BACKUP_DIR/$(basename "$arg").backup_$(tr -cd 'a-f0-9' < /dev/urandom | head -c 8)"  # .backup_$(date +%s) suffix won't be unique in this script
    fi
  done
}

link-file() {
  local sourceFile="$1" destFile="$2"
  mkdir -p "${destFile%/*}"
  backup "$destFile"
  ln -s "${@:3}" "$sourceFile" "$destFile" || ln -s "$sourceFile" "$destFile"
  log "Linked $sourceFile to $destFile"
}

install-devtools() {
  log '\nInstalling development tools..'
  if [[ $OSTYPE = linux-android ]]; then
    pkg upgrade -y -o DPkg::Options::='--force-confnew' && apt update && apt upgrade -y && pkg install -y proot zsh openssh wget git vim termux-exec diffutils fd ripgrep lazygit tmux bat git-delta neovim file  # yazi requires file
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
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils wget xz
    append-once "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix)/opt/coreutils/libexec/gnubin:\$PATH\"" ~/.bashrc ~/.zshrc
    brew install grep && link-file "$(which ggrep)" ~/.local/bin/grep
    brew install gnu-sed && link-file "$(which gsed)" ~/.local/bin/sed
    brew install findutils && link-file "$(which gxargs)" ~/.local/bin/xargs
    brew install gawk && link-file "$(which gawk)" ~/.local/bin/awk
    brew install gnu-tar && link-file "$(which gtar)" ~/.local/bin/tar
    export PATH="$HOME/.local/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    local fpath_line="FPATH=\"$(brew --prefix)/share/zsh/site-functions:\$FPATH\""
    grep -qxF "$fpath_line" ~/.zshrc 2> /dev/null || sed -i -e "1i$fpath_line" ~/.zshrc
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
    # TODO(macOS 26) try https://github.com/Arthur-Ficial/apfel, https://github.com/stonerl/Thaw
    # brew install --cask font-jetbrains-mono-nerd-font wezterm@nightly neovide rectangle linearmouse maccy pixpin trex jordanbaird-ice doll karabiner-elements alt-tab squirrel-app darkmodebuddy coconutbattery handy visual-studio-code orion cardinal-search
    # tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo && tic -x -o ~/.terminfo $tempfile && rm $tempfile
    # to update casks: brew upgrade --cask --greedy
    # to update one cask: brew upgrade --cask wezterm@nightly --greedy-latest
  fi
}

install-dotfiles() {
  log 'Cloning dotfiles..'
  if [[ ! -f ~/.vim/config/.bashrc ]]; then
    backup ~/.vim
    git clone --filter=blob:none https://github.com/joshuali925/.vim.git ~/.vim
  fi
  log 'Creating directories..'
  mkdir -pv ~/.local/{bin,lib} ~/.ssh ~/projects
  log 'Linking configurations..'
  append-once 'source ~/.vim/config/.bashrc' ~/.bashrc
  append-once 'source ~/.vim/config/zsh/.zshrc' ~/.zshrc
  append-once 'skip_global_compinit=1' ~/.zshenv
  log "Ensured 'source ~/.vim/config/.bashrc' in ~/.bashrc"
  log "Ensured 'source ~/.vim/config/zsh/.zshrc' in ~/.zshrc"
  log "Ensured 'skip_global_compinit=1' in ~/.zshenv"
  append-once 'Include ~/.vim/config/ssh_config' ~/.ssh/config
  append-once 'Include ~/.ssh/ec2hosts' ~/.ssh/config
  link-file ~/.vim/config/.tmux.conf ~/.tmux.conf --relative
  link-file ~/.vim/config/.gitconfig ~/.gitconfig --relative
  link-file ~/.vim/config/.ideavimrc ~/.ideavimrc --relative
  link-file ~/.vim/config/yazi ~/.config/yazi --relative
  link-file ~/.vim/config/lazygit_config.yml ~/.config/lazygit/config.yml --relative
  if [[ $PLATFORM = darwin ]]; then
    ln -srf ~/Library/Application\ Support ~/Library/ApplicationSupport
    link-file ~/.vim/config/lazygit_config.yml ~/Library/ApplicationSupport/lazygit/config.yml
    link-file ~/.vim/config/wezterm.lua ~/.config/wezterm/wezterm.lua
    link-file ~/.vim/config/karabiner.json ~/.config/karabiner/assets/complex_modifications/karabiner.json
    mkdir -p ~/.config/neovide && echo 'frame = "none"' > ~/.config/neovide/config.toml
  elif [[ $OSTYPE = linux-android ]]; then
    append-once 'export SSH_CLIENT=1 TMUX_NO_TPM=1' ~/.zshrc
    append-once 'export EDITOR=vim' ~/.zshrc
    append-once "bindkey '\\ej' down-line-or-beginning-search" ~/.zshrc
    append-once "bindkey '\\ek' up-line-or-beginning-search" ~/.zshrc
    append-once "bindkey '\\el' forward-char" ~/.zshrc
    append-once "bindkey '\\e;' beginning-of-line" ~/.zshrc
    append-once "bindkey \"\\e'\" end-of-line" ~/.zshrc
    append-once "bindkey '\\eu' undo" ~/.zshrc
  fi
  log 'Installed dotfiles'
}

install-docker() {
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
  sudo chmod 666 /var/run/docker.sock  # groupadd will take effect after shell re-login and newgrp only changes group for the current shell session. enable read write access for other groups now to work immediately
  docker completion zsh > ~/.vim/config/zsh/completions/_docker
  log 'Installed docker'
}

install-java() {  # JDK list: https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  log "Installing java $JDK_VERSION.."
  mise use -g "java@$JDK_VERSION"
  export JAVA_HOME="$(mise where java)"
  append-once "export JAVA_HOME=\"$JAVA_HOME\"" ~/.bashrc ~/.zshrc
  log "Installed $JDK_VERSION, exported JAVA_HOME to ~/.bashrc and ~/.zshrc, restart your shell"
}

install-system-python() {  # environment for install from source: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  log "Installing python system-wide.."
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

install-node() {
  log "Installing node $NODE_VERSION.."
  MISE_NODE_VERIFY=false mise use -g "nodejs@$NODE_VERSION"
  mise x -- npm config set prefix ~/.local/lib/node-packages
  log 'Installing node packages..'
  mise x -- npm install -g --cache ~/.local/lib/npm-temp-cache "yarn@$YARN_VERSION" || true
  rm -rf ~/.local/lib/npm-temp-cache
  curl -L https://raw.githubusercontent.com/zsh-users/zsh-completions/HEAD/src/_yarn -o ~/.vim/config/zsh/completions/_yarn
  log 'Installed node, yarn'
}

install-tmux() {
  log 'Installing tmux..'
  backup ~/.local/bin/tmux
  tmux -V
  log 'Installing tmux plugins..'
  if [[ ! -d ~/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --depth=1
  else
    TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/ ~/.tmux/plugins/tpm/bin/update_plugins all || true
  fi
  TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/ ~/.tmux/plugins/tpm/bin/install_plugins || true
  if [[ ! -d ~/.terminfo ]]; then
    curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
    tic -xe tmux-256color terminfo.src && rm terminfo.src
    log 'Installed tmux-256colors terminfo to ~/.terminfo'
  fi
  log 'Installed tmux and plugins'
}

install-neovim() {
  log "Installing neovim.."
  link-file ~/.vim/config/nvim ~/.config/nvim --relative
  backup ~/.local/lib/nvim ~/.local/bin/nvim
  ~/.vim/bin/nvim --version
  timeout 120 ~/.local/bin/nvim --headless +quitall || true
  if [[ $PLATFORM = darwin ]]; then
    nvim -u ~/.vim/config/vscode-neovim/vscode.vim -i NONE +PlugInstall +quitall
  fi
  log "\nInstalled neovim and plugins"
}

install-swap() {
  if [[ $PLATFORM != linux ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  local g="${1:-4}"
  log "Installing ${g}G swapfile.."
  sudo swapoff /swapfile || true
  sudo rm -f /swapfile
  sudo dd if=/dev/zero of=/swapfile count=$((g * 1024)) bs=1MiB &
  if [[ $PACKAGE_MANAGER = apt-get ]]; then
    log 'Installing earlyoom..'
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y earlyoom
  fi
  wait
  sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
  grep -qxF '/swapfile swap swap defaults 0 0' /etc/fstab || echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab
  free -h
}

install-pm2() {
  if [[ $PLATFORM != linux ]]; then
    log 'Unsupported platform..'
    return 1
  fi
  npm install -g pm2
  pm2 set pm2:autodump true
  sudo -E "$(mise which node)" "$(mise which pm2)" startup systemd -u "$USER" --hp "$HOME"
}

install-google-chrome() {
  if builtin command -v google-chrome > /dev/null 2>&1; then
    log 'Google Chrome already installed, skipping..'
    return 0
  fi
  if [[ $PLATFORM:$PACKAGE_MANAGER:$ARCHITECTURE = linux:yum:x86_64 ]]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo yum localinstall google-chrome-stable_current_x86_64.rpm
    rm -f google-chrome-stable_current_x86_64.rpm
  elif [[ $PLATFORM:$PACKAGE_MANAGER:$ARCHITECTURE = linux:apt-get:x86_64 ]]; then
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update && sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y google-chrome-stable
  else
    log 'Unsupported platform..'
    return 1
  fi
}

install-claude-code() {
  if builtin command -v claude > /dev/null 2>&1; then claude update; else curl -fsSL https://claude.ai/install.sh | bash; fi
  npm install -g ccstatusline@latest
  if [[ ${1:-} = update ]]; then
    claude plugin marketplace list --json | jq -r '.[].name' | xargs -n1 claude plugin marketplace update
    claude plugin list --json | jq -r '.[].id' | xargs -n1 claude plugin update
    return $?
  fi
  mkdir -p ~/.aws ~/.claude
  append-once '/.claude/' ~/.gitignore
  link-file ~/.vim/config/claude/commands ~/.claude/commands --relative
  link-file ~/.vim/config/claude/settings.json ~/.claude/settings.json --relative
  link-file ~/.vim/config/claude/ccstatusline ~/.config/ccstatusline --relative
  claude plugin marketplace add anthropics/claude-plugins-official
  claude plugin install code-review@claude-plugins-official
  claude plugin install skill-creator@claude-plugins-official && claude plugin disable skill-creator
  claude plugin install superpowers@claude-plugins-official && claude plugin disable superpowers
  claude plugin install typescript-lsp@claude-plugins-official
  claude plugin install frontend-design@claude-plugins-official && claude plugin disable frontend-design
  claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill && claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill && claude plugin disable ui-ux-pro-max
  claude plugin marketplace add snarktank/ralph && claude plugin install ralph-skills@ralph-marketplace && claude plugin disable ralph-skills
  claude plugin marketplace add OthmanAdi/planning-with-files && claude plugin install planning-with-files@planning-with-files && claude plugin disable planning-with-files
  claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman && claude plugin disable caveman
  claude plugin marketplace add tanweai/pua && claude plugin install pua@pua-skills && claude plugin disable pua
  claude plugin marketplace add memvid/claude-brain && claude plugin install mind@memvid
  curl -sL https://github.com/KKKKhazix/khazix-skills/archive/refs/heads/main.tar.gz | tar xz -C ~/.claude/skills/ --strip-components=1 --wildcards '*/neat-freak/*'
  # curl -sL https://github.com/github/gh-stack/archive/refs/heads/main.tar.gz | tar xz -C ~/.claude/skills/ --strip-components=2 --wildcards '*/skills/gh-stack/*'
  # curl -sL https://github.com/jgraph/drawio-mcp/archive/refs/heads/main.tar.gz | tar xz -C ~/.claude/skills/ --strip-components=2 --wildcards '*/skill-cli/drawio/*'
  claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp
  if install-google-chrome 2> /dev/null; then
    npm install -g chrome-devtools-mcp@latest && claude mcp add -s user chrome-devtools -- chrome-devtools-mcp --headless --isolated --no-sandbox --no-usage-statistics
    # npm install -g @playwright/cli@latest && cp -r "$(npm root -g)/@playwright/cli/skills" ~/.claude/skills && append-once '/.playwright-cli/' ~/.gitignore
  fi
  log '\nInstalled Claude Code'
  if ! grep -q '^export AWS_BEARER_TOKEN_BEDROCK=' ~/.zshenv 2>/dev/null; then
    echo 'export AWS_BEARER_TOKEN_BEDROCK=' >> ~/.zshenv
    log "${BG_RED}TODO${CYAN}: update bedrock key in ${YELLOW}~/.zshenv"
  fi
}

install-k3s() {
  curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644
  kubectl completion zsh > ~/.vim/config/zsh/completions/_kubectl
  mise use -g k9s helm stern
  mise x -- k9s completion zsh > ~/.vim/config/zsh/completions/_k9s  # alternative: https://github.com/Ramilito/kubectl.nvim
  mise x -- helm completion zsh > ~/.vim/config/zsh/completions/_helm
  mise x -- stern --completion zsh > ~/.vim/config/zsh/completions/_stern
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
  append-once 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' ~/.bashrc ~/.zshrc
  log 'Installed k3s, k9s, helm, stern'
}

install-ssh-key() {
  if [[ -f ~/.ssh/id_ed25519 ]]; then  # shellcheck disable=2088
    log '~/.ssh/id_ed25519 already exists, skipping..'
    return 0
  fi
  ssh-keygen -t ed25519 -C '' -N '' -f ~/.ssh/id_ed25519 && ssh-keygen -y -f ~/.ssh/id_ed25519
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
    termux-style
    termux-setup-storage && sleep 5 && cp --preserve=links -r ~/storage/downloads ~/downloads
    sed -i 's/#\?setopt NO_CASE_GLOB/#setopt NO_CASE_GLOB/' "$HOME/.local/zim/modules/completion/init.zsh"  # https://github.com/zimfw/zimfw/issues/482#issuecomment-1288943906
  else
    install node &
    install tmux &
    install neovim || true
    wait
  fi

  install ssh-key
  sudo chsh -s "$(which zsh)" "$(whoami)" || true
  log '\nDefault shell will be zsh after re-login'
  log "${YELLOW}SHELL=$(which zsh) exec zsh  ${BLACK}# run zsh now"
  log '\nFinished, exiting..'
}

case $1 in
  '')         default-install ;;
  install)    "$@" ;;
  detect-env) detect-env ;;
  *)          usage ;;
esac
