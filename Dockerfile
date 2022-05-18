FROM ubuntu:20.04

RUN apt-get update; apt-get install -y curl sudo

RUN useradd -s /bin/bash -d /home/docker -m -G sudo docker; passwd -d docker
USER docker
WORKDIR /home/docker

ENV TERM='xterm-256color' SSH_CLIENT=1

# outside context: comment COPY and replace $(cat ...) with $(curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh)
COPY --chown=docker . .vim
RUN bash -c "$(cat ~/.vim/install.sh)" -- install devtools dotfiles neovim
RUN zsh -ic 'source ~/.zinit/plugins/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme clean; ~/.zinit/plugins/romkatv---powerlevel10k/gitstatus/install'; sudo chsh -s $(which zsh) $(whoami) # cannot run interactive shell under RUN
RUN ~/.vim/bin/lf --version; ~/.vim/bin/rg --version; ~/.vim/bin/fd --version; ~/.vim/bin/fzf --version; \
      ~/.vim/bin/bat --version; ~/.vim/bin/lazygit --version; ~/.vim/bin/delta --version; ~/.vim/bin/shellcheck --version;

# # if only using bash
# RUN sudo curl -L -o /usr/bin/bashrc https://raw.githubusercontent.com/joshuali925/.vim/HEAD/bin/bashrc; \
#       sudo chmod +x /usr/bin/bashrc; echo 'exec bashrc' >> ~/.bashrc && bash -ic 'exit'

# use busybox wget if busybox runs (x86_64)
RUN ~/.vim/bin/busybox && ln -sr ~/.vim/bin/busybox ~/.vim/bin/wget || true

# # additional dependencies
# RUN sudo apt-get install -y wget file

CMD ["/usr/bin/zsh"]