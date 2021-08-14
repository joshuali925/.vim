install-from-github() {
  if [ "$#" -lt 4 ]; then
    echo "Usage: install-from-github <executable> <repo> <linux-x64-package-name> <linux-arm-package-name> <tar-flags-array> [<args>]"
    return 0
  fi

  local EXECUTABLE=$1 REPO=$2 LINUX_X64=$3 LINUX_ARM=$4 TAR_FLAGS=$5 PACKAGE URL
  shift 5

  if [ -f $HOME/.local/bin/$EXECUTABLE ]; then
    $HOME/.local/bin/$EXECUTABLE "$@"
    return 0
  fi

  if [ $(uname -s) == 'Darwin' ]; then
    echo "Binary not found, installing for MacOS is not supported" >&2
    return 1
  fi

  if [ $(uname -m) == 'x86_64' ]; then
    PACKAGE=$LINUX_X64
  else
    PACKAGE=$LINUX_ARM
  fi

  URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url.*$PACKAGE" | cut -d '"' -f 4)
  echo "Installing $EXECUTABLE from $URL" >&2
  curl -sL -o- $URL | tar xz -C $HOME/.local/bin "${TAR_FLAGS[@]}"

  $HOME/.local/bin/$EXECUTABLE "$@"
}

