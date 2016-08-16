FROM ubuntu:latest
ENV user juntaki
ENV email me@juntaki.com

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y git ssh software-properties-common sudo tmux emacs-nox
RUN apt-add-repository -y ppa:fish-shell/release-2 &&
    apt-get update &&
    apt-get -y install fish
RUN useradd -m $user
RUN chsh -s /usr/bin/fish $user

USER $user

# user environment
RUN git clone https://github.com/yyuu/pyenv.git ~/.pyenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# my dotfiles
RUN mkdir ~/.dotfiles
RUN git clone https://github.com/juntaki/dotfiles.git ~/.dotfiles/dotfiles
RUN ln -sf ~/.dotfiles/dotfiles/config.fish ~/.config/fish/ &&
    ln -sf ~/.dotfiles/dotfiles/.tmux.conf ~/ &&
RUN git config --global user.email "$email" && \
    git config --global user.name "$user"

# spacemacs
RUN git clone https://github.com/juntaki/dotspacemacs-travis-build.git ~/.dotfiles/dotspacemacs-travis-build
RUN ln -sf ~/.dotfiles/dotspacemacs-travis-build/.spacemacs ~/
## Try twice  https://github.com/syl20bnr/spacemacs/issues/5658
RUN env SHELL=/bin/bash /opt/emacs/bin/emacs -nw -batch -u root -q -kill && \
    env SHELL=/bin/bash /opt/emacs/bin/emacs -nw -batch -u root -q -kill

# golang
ENV GOPATH /home/$user
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN go get -u -v github.com/nsf/gocode &&
    go get -u -v github.com/rogpeppe/godef &&
    go get -u -v golang.org/x/tools/cmd/oracle &&
    go get -u -v golang.org/x/tools/cmd/gorename &&
    go get -u -v golang.org/x/tools/cmd/goimports
