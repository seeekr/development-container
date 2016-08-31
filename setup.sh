#!/bin/bash -x

set -u
source env.sh

./root.sh
sudo -u $user -H ./setting.sh
sudo -u $user -H ./user.sh
