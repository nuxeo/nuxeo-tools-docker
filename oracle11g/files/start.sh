#!/bin/bash -e

. /root/setenv.sh

export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/11g
export PATH=$ORACLE_HOME/bin:$PATH

sed -i -e 's/:N$/:Y/' /etc/oratab

su oracle -c 'lsnrctl start'
su oracle -c 'dbstart -a'

echo
echo *** DATABASE STARTED ***
echo

while true; do sleep 10; done

