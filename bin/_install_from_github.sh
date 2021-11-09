download-script-from-github() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: download-script-from-github <repo> <script-path> [<args>]"
    return 0
  fi

  local repo=$1 script_path=$2
  local executable=$(basename "$script_path")
  shift 2

  if [ ! -x $HOME/.local/bin/$executable ]; then
    mkdir -p $HOME/.local/bin
    echo "Installing $executable from https://raw.githubusercontent.com/$repo/HEAD/$script_path" >&2
    curl -sL -o $HOME/.local/bin/$executable https://raw.githubusercontent.com/$repo/HEAD/$script_path
    chmod +x $HOME/.local/bin/$executable
  fi
  $HOME/.local/bin/$executable "$@"
}

install-from-github() {
  if [ "$#" -lt 4 ]; then
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
