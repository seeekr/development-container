#!/bin/bash -x

set -u
source env.sh

useradd -m $user
mkdir -p /home/$user/.ssh
echo $my_authorized_keys > /home/$user/.ssh/authorized_keys
chmod 700 /home/$user/.ssh
chmod 600 /home/$user/.ssh/authorized_keys
chown -R $user:$user /home/$user/.ssh

apt-get update && apt-get -y upgrade
apt-get -y install git ssh software-properties-common npm wget curl

npm i -g n
npm i -g npm
n latest

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y esl-erlang elixir

echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$user

# sshd
mkdir -p /var/run/sshd
sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
