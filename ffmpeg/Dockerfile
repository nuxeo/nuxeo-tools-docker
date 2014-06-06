# Ubuntu base with ffmpeg packager
#
# VERSION               0.0.1

FROM       debian:wheezy
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -q -y upgrade

# Install basic tools
RUN apt-get -q -y install git wget sudo

# Add build script
ADD package-all.sh /usr/local/src/package-all.sh

ENTRYPOINT ["/usr/local/src/package-all.sh"]

