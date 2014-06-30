#!/bin/bash -e

docker build -t nuxeo/jenkins-slave-base slave-base

if [ ! -d slave-config/tmpfiles ]; then
    mkdir slave-config/tmpfiles
fi
chmod 0700 slave-config/tmpfiles
cp /opt/build/hudson/m2remote/settings.xml slave-config/tmpfiles/
cp /opt/build/hudson/.netrc slave-config/tmpfiles/jenkins_netrc
cp /opt/build/hudson/.s3cfg slave-config/tmpfiles/jenkins_s3cfg
scp hudson@blancheneige:.ssh/id_rsa slave-config/tmpfiles/jenkins_id_rsa
scp hudson@blancheneige:bin/slave.jar slave-config/tmpfiles/slave.jar
cp /opt/build/keystores/gpg/nxpkg-secret.key slave-config/tmpfiles/nxpkg-secret.key
cp /opt/build/keystores/gpg/nxpkg-public.key slave-config/tmpfiles/nxpkg-public.key

docker build -t nuxeo/jenkins-slave-config slave-config

rm -rf slave-config/tmpfiles

docker build -t nuxeo/jenkins-slave-local slave-local

