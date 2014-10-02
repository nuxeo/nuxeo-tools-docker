# test deployment target
#
# VERSION               0.0.1

FROM       ubuntu:trusty
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

# Install sshd
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update || true
RUN apt-get install -q -y openssh-server rsync

# Bloats the initial image but makes test deployments faster
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu-security/ trusty-security multiverse" >> /etc/apt/sources.list
RUN apt-get update || true
RUN apt-get -q -y install locales unzip
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN update-locale LANG=en_US.UTF-8
RUN apt-get install -q -y postgresql libpq-dev python-psycopg2 openjdk-7-jdk libreoffice imagemagick poppler-utils ffmpeg2theora ufraw libwpd-tools git
RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
ENV BUILD_YASM true
RUN cd ffmpeg-nuxeo && ./build-all.sh true
RUN rm -rf ffmpeg-nuxeo

# Add sudoer user
RUN useradd -d /home/ubuntu -m -s /bin/bash ubuntu
RUN echo "\nubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD files/start.sh /start.sh

EXPOSE 22

ENTRYPOINT ["/start.sh"]
