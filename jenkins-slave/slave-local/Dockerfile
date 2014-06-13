# Jenkins slave with config
#
# VERSION               0.0.1

FROM       nuxeo/jenkins-slave-config
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

ADD files/start.sh /start.sh

EXPOSE 22
# With VNC
#EXPOSE 22 5900

ENTRYPOINT ["/start.sh"]

