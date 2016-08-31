#!/bin/bash -x

set -u
source env.sh

useradd -m $user
mkdir -p /home/$user/.ssh
echo $my_authorized_keys > /home/$user/.ssh/authorized_keys
chmod 700 /home/$user/.ssh
chmod 600 /home/$user/.ssh/authorized_keys
chown -R $user:$user /home/$user/.ssh

locale-gen ja_JP.UTF-8

sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
apt-get update && apt-get -y upgrade
apt-get -y install git ssh software-properties-common sudo tmux emacs-nox golang libssl-dev libreadline-dev zlib1g-dev global curl
apt-add-repository -y ppa:fish-shell/release-2
apt-get update
apt-get -y install fish
apt-get clean

curl -O https://storage.googleapis.com/golang/$goversion.tar.gz
tar -C /usr/local -xzf $goversion.tar.gz
rm $goversion.tar.gz

chsh -s /usr/bin/fish $user
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$user

# sshd
mkdir -p /var/run/sshd
sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
