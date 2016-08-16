FROM ubuntu:latest
ENV user juntaki
ENV email me@juntaki.com
ENV pyversion anaconda3-4.1.0
ENV rbversion 2.3.1
ENV goversion go1.7.linux-amd64

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install git ssh software-properties-common sudo tmux emacs-nox golang libssl-dev libreadline-dev zlib1g-dev global curl
RUN apt-add-repository -y ppa:fish-shell/release-2 && \
    apt-get update && \
    apt-get -y install fish
RUN useradd -m $user
RUN chsh -s /usr/bin/fish $user

# golang
RUN curl -O https://storage.googleapis.com/golang/$goversion.tar.gz && \
    tar -C /usr/local -xzf $goversion.tar.gz && \
    rm $goversion.tar.gz
ENV PATH /usr/local/go/bin:$PATH

USER $user

# user environment
RUN git clone https://github.com/yyuu/pyenv.git ~/.pyenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# my dotfiles
RUN mkdir ~/.dotfiles
RUN git clone https://github.com/juntaki/dotfiles.git ~/.dotfiles/dotfiles
RUN mkdir -p ~/.config/fish && \
    ln -sf ~/.dotfiles/dotfiles/config.fish ~/.config/fish/ && \
    ln -sf ~/.dotfiles/dotfiles/.tmux.conf ~/
RUN git config --global user.email "$email" && \
    git config --global user.name "$user"

# spacemacs
RUN git clone https://github.com/juntaki/dotspacemacs-travis-build.git ~/.dotfiles/dotspacemacs-travis-build
RUN ln -sf ~/.dotfiles/dotspacemacs-travis-build/.spacemacs ~/
## Try twice  https://github.com/syl20bnr/spacemacs/issues/5658
RUN env SHELL=/bin/bash emacs -nw -batch -u root -q -kill && \
    env SHELL=/bin/bash emacs -nw -batch -u root -q -kill

# golang packages
ENV GOPATH /home/$user
## source code
RUN go get -u -v github.com/nsf/gocode && \
    go get -u -v github.com/rogpeppe/godef && \
    go get -u -v golang.org/x/tools/cmd/oracle && \
    go get -u -v golang.org/x/tools/cmd/gorename && \
    go get -u -v golang.org/x/tools/cmd/goimports
## files
RUN go get -u -v github.com/motemen/ghq && \
    go get -u -v github.com/github/hub && \
    go get -u -v github.com/peco/peco/cmd/peco

# python
ENV PATH /home/$user/.pyenv/bin:$PATH
RUN pyenv rehash && \
    pyenv install $pyversion && \
    pyenv global $pyversion

ENV PATH /home/$user/.pyenv/versions/$pyversion/bin/:$PATH
RUN conda update -y conda
RUN conda install -y seaborn
RUN pip install keras autoflake
RUN pip install jedi==0.8.1 json-rpc==1.8.1 service_factory==0.1.2

# ruby
ENV PATH /home/$user/.rbenv/bin:$PATH
RUN rbenv rehash && \
    rbenv install $rbversion && \
    rbenv global $rbversion
RUN rbenv exec gem install --no-document  pry pry-doc ruby_parser rubocop
