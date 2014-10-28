# Jenkins slave with config
#
# VERSION               0.0.1

FROM       nuxeo/jenkins-slave-base
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>


RUN echo "\njenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Using intermediary dirs to work around Docker bug #1295

RUN mkdir /opt/jenkins/ssh-broken
RUN chmod 0700 /opt/jenkins/ssh-broken
ADD tmpfiles/jenkins_id_rsa /opt/jenkins/ssh-broken/id_rsa
ADD files/jenkins_id_rsa.pub /opt/jenkins/ssh-broken/id_rsa.pub
ADD files/jenkins_ssh_config /opt/jenkins/ssh-broken/config
ADD tmpfiles/authorized_keys /opt/jenkins/ssh-broken/authorized_keys
RUN chmod 0600 /opt/jenkins/ssh-broken/*

ADD tmpfiles/jenkins_netrc /opt/jenkins/.netrc
RUN chmod 0600 /opt/jenkins/.netrc

ADD tmpfiles/jenkins_s3cfg /opt/jenkins/.s3cfg
RUN chmod 0600 /opt/jenkins/.s3cfg

RUN mkdir -p /opt/build/hudson
ADD tmpfiles/instance.clid /opt/build/hudson/instance.clid

ADD files/jenkins_bashrc /opt/jenkins/.bashrc
ADD files/jenkins_profile /opt/jenkins/.profile
ADD files/jenkins_gitconfig /opt/jenkins/.gitconfig

RUN mkdir -m 0700 /opt/jenkins/m2-broken
ADD tmpfiles/settings.xml /opt/jenkins/m2-broken/settings.xml

RUN mkdir /opt/jenkins/bin
ADD tmpfiles/slave.jar /opt/jenkins/bin/slave.jar

RUN mkdir /opt/jenkins/workspace

RUN chown -R jenkins:jenkins /opt/jenkins
RUN sh -c 'cp -Rp /opt/jenkins/ssh-broken /opt/jenkins/.ssh && rm -rf /opt/jenkins/ssh-broken'
RUN sh -c 'cp -Rp /opt/jenkins/m2-broken/* /opt/jenkins/.m2/ && rm -rf /opt/jenkins/m2-broken'

ADD tmpfiles/keystores /opt/build/keystores
RUN su jenkins -c 'gpg --allow-secret-key-import --import /opt/build/keystores/gpg/nxpkg-secret.key'
RUN su jenkins -c 'gpg --import /opt/build/keystores/gpg/nxpkg-public.key'
ADD tmpfiles/keystores/keytabs/krb5.conf /etc/krb5.conf

