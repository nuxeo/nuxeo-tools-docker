#!/bin/bash -e

. /root/setenv.sh

echo
echo "* Preparing installation files"
echo

if [ -d /tmpinstall/tmp ]; then
    rm -rf /tmpinstall/tmp
fi
mkdir /tmpinstall/tmp
unzip -d /tmpinstall/tmp -o -q /tmpinstall/linux.x64_11gR2_database_1of2.zip
unzip -d /tmpinstall/tmp -o -q /tmpinstall/linux.x64_11gR2_database_2of2.zip
cp /tmpinstall/db.rsp /tmpinstall/tmp/db.rsp
cp /tmpinstall/netca.rsp /tmpinstall/tmp/netca.rsp
chown -R oracle:oracle /tmpinstall/tmp

echo
echo "* Performing installation"
echo

su oracle -c '/tmpinstall/tmp/database/runInstaller -silent -force -ignorePrereq -waitforcompletion -responseFile /tmpinstall/tmp/db.rsp'

/opt/oraInventory/orainstRoot.sh
/opt/oracle/11g/root.sh

echo
echo "* Creating database"
echo

su oracle -c '/opt/oracle/11g/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbname NUXEO -sid NUXEO -sysPassword nuxeo -systemPassword nuxeo -emConfiguration none -redoLogFileSize 100 -storageType FS -characterSet AL32UTF8 -totalMemory 4096'

echo
echo "* Creating listener"
echo

su oracle -c 'Xvfb :1 -ac -screen 0 1280x1024x16 &'
export DISPLAY=:1
su oracle -c '/opt/oracle/11g/bin/netca -silent -responsefile /tmpinstall/tmp/netca.rsp'
killall Xvfb

echo
echo "* Cleaning up installation files"
echo

rm -rf /tmpinstall/tmp

