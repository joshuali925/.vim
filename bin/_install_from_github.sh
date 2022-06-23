detect-env() {
  source ~/.vim/install.sh detect-env
}

install-from-url() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <executable> <url> [<args>]"
    return 0
  fi

  local executable=$1 url=$2
  shift 2

  if [ ! -x "$HOME/.local/bin/$executable" ]; then
    mkdir -p "$HOME/.local/bin"
    echo "Installing $executable from $url" >&2
    curl -sL -o "$HOME/.local/bin/$executable" "$url"
    chmod +x "$HOME/.local/bin/$executable"
  fi
  "$HOME/.local/bin/$executable" "$@"
}

install-from-github() {
  if [ "$#" -lt 7 ]; then
    echo "Usage: $0 <executable> <repo> <linux-x64-package-name> <linux-arm64-package-name> <macos-x64-package-name> <macos-arm64-package-name> <extract-command-flags> [<args>]"
    return 0
  fi

  local executable=$1 repo=$2 linux_x64=$3 linux_arm=$4 darwin_x64=$5 darwin_arm=$6 extract_flags=$7
  shift 7

  if [ -x "$HOME/.local/bin/$executable" ]; then
    "$HOME/.local/bin/$executable" "$@"
    return 0
  fi

  detect-env
  local package url extract_cmd tar_cmd='tar'
  if [ "$ARCHITECTURE" == 'x86_64' ]; then
    [ "$PLATFORM" == 'linux' ] && package=$linux_x64 || package=$darwin_x64
  else
    [ "$PLATFORM" == 'linux' ] && package=$linux_arm || package=${darwin_arm:-$darwin_x64}
  fi
  if [ "$PLATFORM" == 'darwin' ]; then
    if ! builtin command -V gtar > /dev/null 2>&1; then
      echo 'gnu-tar not installed, trying with tar' >&2
    else
      tar_cmd='gtar'
    fi
  fi
  if [ -z "$package" ]; then
    echo "package not found for '$executable' on $PLATFORM $ARCHITECTURE, exiting.." >&2
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep "browser_download_url.*$package" | head -n 1 | cut -d '"' -f 4)
  [ -z "$url" ] && echo "Unable to get $repo url for $package" >&2 && return 1
  echo "Installing $executable from $url" >&2
  case $url in
    # *.rar)                       extract_cmd="unrar x" ;;
    # *.7z)                        extract_cmd="7z x"    ;;
    *.tar)                       extract_cmd="$tar_cmd x -C $HOME/.local/bin"                ;;
    *.tar.gz | *.tgz)            extract_cmd="$tar_cmd xz -C $HOME/.local/bin"               ;;
    *.tar.xz | *.xz)             extract_cmd="$tar_cmd xJ -C $HOME/.local/bin"               ;;
    *.tar.bz2 | *.tbz | *.tbz2)  extract_cmd="$tar_cmd xj -C $HOME/.local/bin"               ;;
    *.bz2)                       extract_cmd="bunzip2 | tee $HOME/.local/bin/$executable"    ;;
    *.gz)                        extract_cmd="gunzip | tee $HOME/.local/bin/$executable"     ;;
    *.zip)                       extract_cmd="tee $HOME/.local/bin/${executable}.archive > /dev/null && unzip -j -d $HOME/.local/bin $HOME/.local/bin/${executable}.archive $extract_flags && rm $HOME/.local/bin/${executable}.archive; echo" ;;
    *.Z)                         extract_cmd="uncompress | tee $HOME/.local/bin/$executable" ;;
    *)                           extract_cmd="tee $HOME/.local/bin/$executable"              ;;
  esac

  curl -sL -o- "$url" | eval "$extract_cmd $extract_flags" > /dev/null
  chmod +x "$HOME/.local/bin/$executable"
  "$HOME/.local/bin/$executable" "$@"
}
