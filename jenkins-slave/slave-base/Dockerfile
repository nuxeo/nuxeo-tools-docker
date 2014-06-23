# Jenkins slave base
#
# VERSION               0.0.1

FROM       ubuntu:trusty
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

RUN echo "deb http://netboot.in.nuxeo.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://netboot.in.nuxeo.com/ubuntu-security/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -q -y upgrade

# Install basic tools
RUN apt-get -q -y install ssh sudo lynx links curl wget sysstat logtail vim build-essential zip unzip moreutils apt-transport-https

# Install tools for Jenkins
RUN mkdir -p /opt/build/tools

RUN apt-get -q -y install openjdk-6-jdk openjdk-7-jdk git mercurial subversion ant ant-contrib  xvfb x11vnc fluxbox chromium-browser
RUN ln -s /usr/lib/jvm/java-1.7.0-openjdk-amd64 /usr/lib/jvm/java-7-openjdk

## Firefox
RUN wget -O /tmp/firefox.tar.bz2 http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/26.0/linux-x86_64/en-US/firefox-26.0.tar.bz2
RUN tar xjf /tmp/firefox.tar.bz2 -C /opt/build/tools
RUN ln -s /opt/build/tools/firefox/firefox /usr/bin/firefox
RUN rm /tmp/firefox.tar.bz2

## Maven
RUN wget -O /tmp/maven-2.2.1.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz
RUN tar xzf /tmp/maven-2.2.1.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-2.2.1 /opt/build/tools/maven2
RUN rm /tmp/maven-2.2.1.tar.gz

RUN wget -O /tmp/maven-3.0.5.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-3.0.5-bin.tar.gz
RUN tar xzf /tmp/maven-3.0.5.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-3.0.5 /opt/build/tools/maven-3.0
RUN rm /tmp/maven-3.0.5.tar.gz

RUN wget -O /tmp/maven-3.1.1.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-3.1.1-bin.tar.gz
RUN tar xzf /tmp/maven-3.1.1.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-3.1.1 /opt/build/tools/maven-3.1
RUN rm /tmp/maven-3.1.1.tar.gz

RUN wget -O /tmp/maven-3.2.1.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-3.2.1-bin.tar.gz
RUN tar xzf /tmp/maven-3.2.1.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-3.2.1 /opt/build/tools/maven-3.2
RUN rm /tmp/maven-3.2.1.tar.gz

RUN ln -s /opt/build/tools/maven-3.2/bin/mvn /usr/bin/mvn

## Gradle
RUN wget -O /tmp/gradle.zip http://services.gradle.org/distributions/gradle-1.6-bin.zip
RUN unzip -d /opt/build/tools /tmp/gradle.zip
RUN ln -s /opt/build/tools/gradle-1.6 /opt/build/tools/gradle
RUN ln -s /opt/build/tools/gradle/bin/gradle /usr/bin/gradle
RUN rm /tmp/gradle.zip


# Install other misc dependencies
RUN apt-get -q -y install linkchecker s3cmd python-dev python-setuptools python-lxml python-webunit python-docutils python-reportlab python-pypdf gnuplot python-pip tcpwatch-httpproxy dpkg-dev devscripts debhelper gnupg
RUN easy_install -f http://funkload.nuxeo.org/snapshots/ -U funkload
RUN echo "deb https://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update
RUN apt-get -q -y install lxc-docker

# Install converters
RUN apt-get -q -y install imagemagick ffmpeg2theora ufraw poppler-utils libreoffice libwpd-tools gimp
RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
ENV BUILD_YASM true
RUN cd ffmpeg-nuxeo && ./build-all.sh true

