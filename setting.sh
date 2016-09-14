#!/bin/bash -x

set -u
source env.sh

# my dotfiles
mkdir -p ~/.config/fish
curl $my_configfish -o ~/.config/fish/config.fish
curl $my_dottmuxconf -o ~/.tmux.conf
git config --global user.email "$email"
git config --global user.name "$user"
git config --global push.default simple

git config --global --replace-all ghq.root /home/juntaki/.ghq
git config --global --add ghq.root /home/juntaki/.go

# http://blog.n-z.jp/blog/2014-07-05-ghq-gitconfig.html
# github upload
GITHUB_URL_PREFIX="url.git@github.com:"
git config --global --remove-section "$GITHUB_URL_PREFIX" || :
git config --global "$GITHUB_URL_PREFIX".pushInsteadOf "git://github.com/"
git config --global --add "$GITHUB_URL_PREFIX".pushInsteadOf "https://github.com/"
# gist upload
git config --global "url.git@gist.github.com:".pushInsteadOf "https://gist.github.com/$(git config github.user)/"
# github download
git config --global url."git://github.com/".insteadOf "https://github.com/"

# spacemacs
curl $my_dotspacemacs -o ~/.spacemacs
## Try twice  https://github.com/syl20bnr/spacemacs/issues/5658
env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill
env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill
