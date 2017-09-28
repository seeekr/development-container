#!/bin/bash

KEY_LOCATION=/data/dev
[[ ! -f ${KEY_LOCATION}/id_rsa ]] || cp ${KEY_LOCATION}/id_rsa* ~/.ssh/

/usr/sbin/sshd -D
