#!/bin/bash -x

set -u
source env.sh

# golang
export PATH=/usr/local/go/bin:$PATH

# user environment
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# golang packages
export GOPATH=/home/$user/go
## source code
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v golang.org/x/tools/cmd/oracle
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v golang.org/x/tools/cmd/goimports
## files
go get -u -v github.com/motemen/ghq
go get -u -v github.com/github/hub
go get -u -v github.com/peco/peco/cmd/peco

# python
export PATH=/home/$user/.pyenv/bin:$PATH
pyenv rehash
pyenv install $pyversion
pyenv global $pyversion

export PATH=/home/$user/.pyenv/versions/$pyversion/bin/:$PATH
conda update -y conda
conda install -y seaborn
pip install keras autoflake
pip install jedi==0.8.1 json-rpc==1.8.1 service_factory==0.1.2

# ruby
export PATH=/home/$user/.rbenv/bin:$PATH
rbenv rehash
rbenv install $rbversion
rbenv global $rbversion
rbenv exec gem install --no-document  pry pry-doc ruby_parser rubocop
