detect-env() {
  local sys_bit=$(uname -m)
  case $sys_bit in
    # mac shows i386 for x86_64
    i[36]86 | 'amd64' | x86_64)
      ARCHITECTURE="x86_64" ;;
    *armv6*)
      ARCHITECTURE="arm6" ;;
    *armv7*)
      ARCHITECTURE="arm7" ;;
    *aarch64* | *armv8* | arm64)
      ARCHITECTURE="arm64" ;;
    *)
      echo "$sys_bit not supported, exiting.." >&2
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

install-from-url() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: install-from-url <executable> <url> [<args>]"
    return 0
  fi

  local executable=$1 url=$2
  shift 2

  if [ ! -x $HOME/.local/bin/$executable ]; then
    mkdir -p $HOME/.local/bin
    echo "Installing $executable from $url" >&2
    curl -sL -o $HOME/.local/bin/$executable $url
    chmod +x $HOME/.local/bin/$executable
  fi
  $HOME/.local/bin/$executable "$@"
}

install-from-github() {
  if [ "$#" -lt 7 ]; then
    echo "Usage: install-from-github <executable> <repo> <linux-x64-package-name> <linux-arm-package-name> <macos-x64-package-name> <macos-arm-package-name> <extract-command-flags> [<args>]"
    return 0
  fi

  local executable=$1 repo=$2 linux_x64=$3 linux_arm=$4 darwin_x64=$5 darwin_arm=$6 extract_flags=$7
  shift 7

  if [ -f $HOME/.local/bin/$executable ]; then
    $HOME/.local/bin/$executable "$@"
    return 0
  fi

  local package url architecture="$(uname -m)" os="$(uname -s)" extract_cmd tar_cmd='tar'
  if [ "$architecture" == 'x86_64' ] || [ "$architecture" == 'amd64' ] || [ "$architecture" == 'i386' ]; then
    [ "$os" == 'Linux' ] && package=$linux_x64 || package=$darwin_x64
  else
    if [ "$os" == 'Linux' ]; then
      package=$linux_arm
    else
      [ -z "$darwin_arm" ] && package=$darwin_x64 || package=$darwin_arm
    fi
  fi
  if [ "$os" == 'Darwin' ]; then
    if ! (builtin command -V gtar >/dev/null 2>&1); then
      echo 'gnu-tar not installed, trying with tar' >&2
    else
      tar_cmd='gtar'
    fi
  fi
  if [ -z "$package" ]; then
    echo 'Package not found, exiting..' >&2
    return 1
  fi

  mkdir -p $HOME/.local/bin
  url=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep "browser_download_url.*$package" | cut -d '"' -f 4)
  case $url in
    *.tar.bz2)  extract_cmd="$tar_cmd xj"      ;;
    *.tar.xz)   extract_cmd="$tar_cmd xJ"      ;;
    *.tar.gz)   extract_cmd="$tar_cmd xz"      ;;
    *.bz2)      extract_cmd="bunzip2"          ;;
    *.rar)      extract_cmd="unrar x"          ;;
    *.gz)       extract_cmd="gunzip"           ;;
    *.tar)      extract_cmd="$tar_cmd x"       ;;
    *.tbz2)     extract_cmd="$tar_cmd xj"      ;;
    *.tgz)      extract_cmd="$tar_cmd xz"      ;;
    *.zip)      extract_cmd="unzip"            ;;
    *.xz)       extract_cmd="unxz"             ;;
    *.Z)        extract_cmd="uncompress"       ;;
    *.7z)       extract_cmd="7z x"             ;;
    *)          extract_cmd="$tar_cmd xz"      ;;
  esac

  echo "Installing $executable from $url" >&2
  curl -sL -o- $url | $extract_cmd -C $HOME/.local/bin $(echo "$extract_flags")

  $HOME/.local/bin/$executable "$@"
}
