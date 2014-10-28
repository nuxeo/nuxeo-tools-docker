#!/bin/bash -e


if [ ! -d slave-base/tmpfiles ]; then
    mkdir slave-base/tmpfiles
    mkdir slave-base/tmpfiles/m2repo
fi
cp -a /opt/build/m2_repo_seed/* slave-base/tmpfiles/m2repo/
docker build -t nuxeo/jenkins-slave-base slave-base
rm -rf slave-base/tmpfiles

if [ ! -d slave-config/tmpfiles ]; then
    mkdir slave-config/tmpfiles
fi
chmod 0700 slave-config/tmpfiles
cp /opt/build/hudson/m2remote/settings.xml slave-config/tmpfiles/
cp /opt/build/hudson/.netrc slave-config/tmpfiles/jenkins_netrc
cp /opt/build/hudson/.s3cfg slave-config/tmpfiles/jenkins_s3cfg
cp /opt/build/hudson/instance.clid slave-config/tmpfiles/
scp hudson@blancheneige:.ssh/id_rsa slave-config/tmpfiles/jenkins_id_rsa
scp hudson@blancheneige:bin/slave.jar slave-config/tmpfiles/slave.jar
cat slave-config/files/jenkins_id_rsa.pub /opt/build/hudson/authorized_keys/* > slave-config/tmpfiles/authorized_keys

cp -a /opt/build/keystores slave-config/tmpfiles/keystores

docker build -t nuxeo/jenkins-slave-config slave-config

rm -rf slave-config/tmpfiles

docker build -t nuxeo/jenkins-slave-local slave-local

