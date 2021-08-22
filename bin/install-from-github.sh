install-from-github() {
  if [ "$#" -lt 4 ]; then
    echo "Usage: install-from-github <executable> <repo> <linux-x64-package-name> <linux-arm-package-name> <extract-command-flags> [<args>]"
    return 0
  fi

  local executable=$1 repo=$2 linux_x64=$3 linux_arm=$4 extract_flags=$5
  shift 5

  if [ -f $HOME/.local/bin/$executable ]; then
    $HOME/.local/bin/$executable "$@"
    return 0
  fi

  if [ $(uname -s) != 'Linux' ]; then
    echo "Binary not found, only supports installing for linux, exiting.." >&2
    return 1
  fi

  local package url architecture="$(uname -m)" extract_cmd
  if [ $architecture == 'x86_64' ] || [ $architecture == 'amd64' ]; then
    package=$linux_x64
  else
    package=$linux_arm
  fi

  mkdir -p $HOME/.local/bin
  url=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep "browser_download_url.*$package" | cut -d '"' -f 4)
  case $url in
    *.tar.bz2) extract_cmd='tar xj' ;;
    *.tar.xz) extract_cmd='tar xJ' ;;
    *.tar.gz) extract_cmd='tar xz' ;;
    *.bz2) extract_cmd='bunzip2' ;;
    *.rar) extract_cmd='unrar x' ;;
    *.gz) extract_cmd='gunzip' ;;
    *.tar) extract_cmd='tar x' ;;
    *.tbz2) extract_cmd='tar xj' ;;
    *.tgz) extract_cmd='tar xz' ;;
    *.zip) extract_cmd='unzip' ;;
    *.xz) extract_cmd='unxz' ;;
    *.Z) extract_cmd='uncompress' ;;
    *.7z) extract_cmd='7z x' ;;
    *) extract_cmd='tar xz' ;;
  esac

  echo "Installing $executable from $url" >&2
  curl -sL -o- $url | $extract_cmd -C $HOME/.local/bin $(echo "$extract_flags")

  $HOME/.local/bin/$executable "$@"
}
