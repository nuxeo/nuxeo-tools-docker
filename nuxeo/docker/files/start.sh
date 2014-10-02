#!/bin/bash

if [ ! -f /pubkey ]; then
    echo "Please mount your public ssh key on /pubkey"
    exit 1
fi

mkdir -p /home/ubuntu/.ssh
cp /pubkey /home/ubuntu/.ssh/authorized_keys
chmod -R og-rwx /home/ubuntu/.ssh
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

mkdir -p /var/run/sshd
/usr/sbin/sshd -D

