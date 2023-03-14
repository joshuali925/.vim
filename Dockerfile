FROM ubuntu:22.04

# add additional dependencies
RUN apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y curl sudo

RUN useradd -s /bin/bash -d /home/docker -m -G sudo docker; passwd -d docker
USER docker
WORKDIR /home/docker
ENV TERM=xterm-256color SSH_CLIENT=1 SHELL=/usr/bin/zsh USER=docker

## if only using bash
# RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc)" -- -c 'echo "exec ~/.vim/bin/bashrc" >> ~/.bashrc'
# CMD ["/usr/bin/bash"]

## outside context: comment COPY and replace $(cat ...) with $(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)
COPY --chown=docker . .vim
RUN bash -c "$(cat ~/.vim/install.sh)" -- install devtools dotfiles neovim
RUN zsh -ic 'source ~/.zinit/plugins/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme clean'; sudo chsh -s $(which zsh) $(whoami)
RUN ~/.vim/bin/lf --version; ~/.vim/bin/rg --version; ~/.vim/bin/fd --version; ~/.vim/bin/fzf --version; \
      ~/.vim/bin/bat --version; ~/.vim/bin/lazygit --version; ~/.vim/bin/delta --version; \
      ~/.vim/bin/busybox > /dev/null && ln -sr ~/.vim/bin/busybox ~/.local/bin/wget || true  # install binaries and use busybox wget if busybox runs (x86_64)
CMD ["/usr/bin/zsh"]
