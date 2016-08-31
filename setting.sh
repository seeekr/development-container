#!/bin/bash -x

set -u
source env.sh

# my dotfiles
mkdir -p ~/.config/fish
curl $my_configfish -o ~/.config/fish/config.fish
curl $my_dottmuxconf -o ~/.tmux.conf
git config --global user.email "$email"
git config --global user.name "$user"
git config --global ghq.root /home/$user/work/ghq
git config --global push.default simple

# spacemacs
curl $my_dotspacemacs -o ~/.spacemacs
## Try twice  https://github.com/syl20bnr/spacemacs/issues/5658
env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill
env SHELL=/bin/bash emacs -nw -batch -u $user -q -kill
