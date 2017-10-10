#!/bin/bash -x

set -u
source env.sh

home=/root

mkdir -p $home/.ssh
cat << EOF >> $home/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr2W9HZr9x2FXbdGy1WDHXad9L+bLnEl5Wv2B1QpNjyZ1t1wy/duzQhVXq7pU8gybZQtmMMPXzrZSlh8Zs3d3sFtAQ0G2QBnWpapgpxMHjDSZmfPDk1yTkdKKoC5ALz1Slo2pe0OOqCYs/fRcAf1q7h3XzhHJBATv60KUKfD3BTPuCNV2T1Lmu19nAKo0qzeSSNCTGZjZlL39E+sZRLlp1RWui8qza1UO9bxxqE617AUqhLYK/p9I7vy6ZlkFyzv+cVcEnRHSUFbay8xoIlnnXvdjorWIjetQ3up01uClBWnhdOEW7YT5zRQxnoDHpz2Qs5sGp7dWeUk1yEYpMQ5SBQ== denis@denis-desktop
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChh+kqNrTGGzEUA7KDo/ay81cNzBv561QDU9KwXVafUxYBMkTi+les15wiTs/uD6bbb7dw9P+nnCuGKgtFatcvcnHwkeS2Xp7OaQQoH2ANG6psJhhPL18hC5GfE0aQ0LGroghDm5z7fnIBxw7dy6SkFQqU0DWHYkTjGInaUOxl8UW4mfJtJa+PT7dUwMAuqVuGQ9X1HV+pmGgK3yBxWOApR1z3Zgo6V+CR2+8LJ/YpnsZl33P/pACmPck2CC+W2+cHAJxvMcYSryVsUNooidsR+EPRYhMyv69pjyG7hJU/gtWQVVpPzdXnElBoDRqdGyfhAJOOpkxSdFOZ9vVkybFt/tuEmNoVSxFIXcKiTeiPMBJIVtmOPxEVFPuTohGiUaSdCgpJSZW8q2QnRSXMwf+9Y1P80x3SFcJKXzzwDsIh4N1KBYjTahbmbBRt7cu37hCKICkz4HHscwpZ3+VNS0HeBIAtrAgkgTnm/6jUp/VvYc7wzqGBBSQYCZhk0k8tOWxERn0etgtP4Rumb1oZ0aS+Qmdw3idXfc4ZKLzv5jqb6cfpfKsEjlLD+X1nX7q0yPztTKdaMTtuL5h+xIdc70A0USCCJFC0V/tO3m+EdKEu0ANGlTiSqESlGy+CXCZJgrWtwfjBV2rI6OuvQzpvGEdnFmityerv/O4wc0w6SHHKWw== eiji@openSUSE
EOF
chmod 700 $home/.ssh
chmod 600 $home/.ssh/authorized_keys

apt-get update && apt-get -y upgrade
apt-get -y install git ssh software-properties-common npm wget curl vim locales \
  mariadb-client

# set utf8 default locale
cat << EOF >> /etc/default/locale
LANG=en_US.UTF-8
EOF
locale-gen "en_US.UTF-8"
cat << EOF >> $home/.bashrc
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
EOF

npm i -g n
npm i -g npm
n latest

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb && rm -f erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y esl-erlang elixir

# sshd
mkdir -p /var/run/sshd
sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

