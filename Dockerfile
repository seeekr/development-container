FROM ubuntu:xenial

ENV user juntaki
ENV email me@juntaki.com
ENV pyversion anaconda3-4.1.0
ENV rbversion 2.3.1
ENV goversion go1.7.linux-amd64

ENV my_dotspacemacs https://raw.githubusercontent.com/juntaki/dotspacemacs-travis-build/master/.spacemacs
ENV my_configfish https://raw.githubusercontent.com/juntaki/dotfiles/master/config.fish
ENV my_dottmuxconf https://raw.githubusercontent.com/juntaki/dotfiles/master/.tmux.conf

RUN locale-gen ja_JP.UTF-8
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install git ssh software-properties-common sudo tmux emacs-nox golang libssl-dev libreadline-dev zlib1g-dev global curl && \
    apt-add-repository -y ppa:fish-shell/release-2 && \
    apt-get update && \
    apt-get -y install fish && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN useradd -m $user && \
    gpasswd -a $user sudo && \
    chsh -s /usr/bin/fish $user

# golang
RUN curl -O https://storage.googleapis.com/golang/$goversion.tar.gz && \
    tar -C /usr/local -xzf $goversion.tar.gz && \
    rm $goversion.tar.gz
ENV PATH /usr/local/go/bin:$PATH

USER $user

# user environment
RUN git clone https://github.com/yyuu/pyenv.git ~/.pyenv && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# my dotfiles
RUN mkdir -p ~/.config/fish && \
    curl $my_configfish -o ~/.config/fish/config.fish && \
    curl $my_dottmuxconf -o ~/.tmux.conf && \
    git config --global user.email "$email" && \
    git config --global user.name "$user" && \
    git config --global ghq.root /home/$user/work/ghq

# spacemacs
RUN curl $my_dotspacemacs -o ~/.spacemacs && \
## Try twice  https://github.com/syl20bnr/spacemacs/issues/5658
    env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill && \
    env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill

# golang packages
ENV GOPATH /home/$user/go
## source code
RUN go get -u -v github.com/nsf/gocode && \
    go get -u -v github.com/rogpeppe/godef && \
    go get -u -v golang.org/x/tools/cmd/oracle && \
    go get -u -v golang.org/x/tools/cmd/gorename && \
    go get -u -v golang.org/x/tools/cmd/goimports && \
## files
    go get -u -v github.com/motemen/ghq && \
    go get -u -v github.com/github/hub && \
    go get -u -v github.com/peco/peco/cmd/peco

# python
ENV PATH /home/$user/.pyenv/bin:$PATH
RUN pyenv rehash && \
    pyenv install $pyversion && \
    pyenv global $pyversion

ENV PATH /home/$user/.pyenv/versions/$pyversion/bin/:$PATH
RUN conda update -y conda && \
    conda install -y seaborn && \
    pip install keras autoflake && \
    pip install jedi==0.8.1 json-rpc==1.8.1 service_factory==0.1.2

# ruby
ENV PATH /home/$user/.rbenv/bin:$PATH
RUN rbenv rehash && \
    rbenv install $rbversion && \
    rbenv global $rbversion && \
    rbenv exec gem install --no-document  pry pry-doc ruby_parser rubocop

USER root

# sshd
RUN mkdir /var/run/sshd && \
    sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

COPY authorized_keys /home/juntaki/.ssh/authorized_keys
RUN chmod 700 /home/juntaki/.ssh && \
    chmod 700 /home/juntaki/.ssh/authorized_keys && \
    chown -R juntaki:juntaki /home/juntaki/.ssh

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]