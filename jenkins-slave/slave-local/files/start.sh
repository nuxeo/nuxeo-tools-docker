#!/bin/bash


. /lib/init/vars.sh
. /lib/lsb/init-functions

start-stop-daemon --start --name Xvfb --background --chuid jenkins --startas /usr/bin/Xvfb -- :1 -ac -screen 0 1280x1024x16
#start-stop-daemon --start --name x11vnc --background --chuid jenkins --startas /usr/bin/x11vnc -- -display :1 -nopw -forever -quiet
start-stop-daemon --start --name fluxbox --background --chuid jenkins --startas /usr/bin/fluxbox -- -display :1

# Update slave.jar
su jenkins -c "scp hudson@blancheneige.in.nuxeo.com:bin/slave.jar /opt/jenkins/bin/slave.jar"

chown jenkins:jenkins /opt/jenkins/workspace
mkdir -p /var/run/sshd
/usr/sbin/sshd -D
# Debug mode
#/usr/sbin/sshd -D -e -d

start-stop-daemon --chuid jenkins --stop --name fluxbox
#start-stop-daemon --chuid jenkins --stop --name x11vnc
start-stop-daemon --chuid jenkins --stop --name Xvfb

