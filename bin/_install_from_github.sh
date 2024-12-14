set -eo pipefail

if [[ $DOT_VIM_LOCAL_BIN = 1 ]]; then echo 'Configured to local-bin only, exiting..' >&2; exit 1; fi

detect-env() {
  source ~/.vim/install.sh detect-env
}

run-if-exists() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <executable> [<args>]" >&2
    return 0
  fi

  local executable=${1##*/}
  shift 1

  if [[ -x ~/.local/bin/$executable ]]; then
    exec "$HOME/.local/bin/$executable" "$@"
  fi
}

install-from-url() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <executable> <url> [<args>]" >&2
    return 0
  fi

  local executable=$1 url=$2
  shift 2

  run-if-exists "$executable" "$@"

  mkdir -p ~/.local/bin
  echo "Installing $executable from $url" >&2
  curl -sL -o "$HOME/.local/bin/$executable" "$url"
  chmod +x "$HOME/.local/bin/$executable"
  run-if-exists "$executable" "$@"
}

install-from-github() {
  if [[ $# -lt 7 ]]; then
    echo "Usage: $0 <executable> <repo> <linux-x64-package-name> <linux-arm64-package-name> <macos-x64-package-name> <macos-arm64-package-name> <extract-command-flags> [<args>]" >&2
    return 0
  fi

  local executable=$1 repo=$2 linux_x64=$3 linux_arm=$4 darwin_x64=$5 darwin_arm=$6 extract_flags=$7 package url
  shift 7

  run-if-exists "$executable" "$@"

  detect-env
  case $PLATFORM:$ARCHITECTURE in
    linux:x86_64) package=$linux_x64 ;;
    linux:arm64) package=$linux_arm ;;
    darwin:x86_64) package=$darwin_x64 ;;
    darwin:arm64) package=${darwin_arm:-$darwin_x64}
      [[ -z $darwin_arm ]] && [[ -n $darwin_x64 ]] && echo "darwin_arm package not found for '$executable', using darwin_x64 package.." >&2 ;;
  esac
  [[ -z $package ]] && echo "package not found for '$executable' on $PLATFORM $ARCHITECTURE, exiting.." >&2 && return 1

  mkdir -p ~/.local/bin
  url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep "browser_download_url.*$package" | head -n 1 | cut -d '"' -f 4) || true
  [[ -z $url ]] && echo "Unable to find '$package' in results of curl 'https://api.github.com/repos/$repo/releases/latest'" >&2 && return 1
  install-archive-from-url "$url" "$executable" "$extract_flags" "$@"
}

install-archive-from-url() {
  if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <url> <executable> <extract-command-flags> [<args>]" >&2
    return 0
  fi

  local url=$1 executable=$2 extract_flags=$3 tar_cmd=tar extract_cmd
  shift 3

  detect-env
  if [[ $PLATFORM = darwin ]]; then
    if ! builtin command -V gtar > /dev/null 2>&1; then
      echo 'gnu-tar not installed, trying with tar' >&2
    else
      tar_cmd='gtar'
    fi
  fi

  echo "Installing $executable from $url" >&2
  case $url in
    # *.rar)                       extract_cmd="unrar x" ;;
    *.tar)                       extract_cmd="$tar_cmd x -C $HOME/.local/bin"                ;;
    *.tar.gz | *.tgz)            extract_cmd="$tar_cmd xz -C $HOME/.local/bin"               ;;
    *.tar.xz | *.xz)             extract_cmd="$tar_cmd xJ -C $HOME/.local/bin"               ;;
    *.tar.bz2 | *.tbz | *.tbz2)  extract_cmd="$tar_cmd xj -C $HOME/.local/bin"               ;;
    *.bz2)                       extract_cmd="bunzip2 | tee $HOME/.local/bin/$executable"    ;;
    *.gz)                        extract_cmd="gunzip | tee $HOME/.local/bin/$executable"     ;;
    *.zip)                       extract_cmd="tee $HOME/.local/bin/${executable}.archive > /dev/null && unzip -j -o -d $HOME/.local/bin $HOME/.local/bin/${executable}.archive $extract_flags && rm $HOME/.local/bin/${executable}.archive; echo" ;;
    *.7z)                        extract_cmd="tee $HOME/.local/bin/${executable}.archive > /dev/null && 7z e -o$HOME/.local/bin $HOME/.local/bin/${executable}.archive $extract_flags && rm $HOME/.local/bin/${executable}.archive; echo" ;;
    *.Z)                         extract_cmd="uncompress | tee $HOME/.local/bin/$executable" ;;
    *)                           extract_cmd="tee $HOME/.local/bin/$executable"              ;;
  esac

  curl -sL -o- "$url" | eval "$extract_cmd $extract_flags" > /dev/null
  chmod +x "$HOME/.local/bin/$executable"
  run-if-exists "$executable" "$@"
}
