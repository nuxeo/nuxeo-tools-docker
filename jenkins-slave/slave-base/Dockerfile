# Jenkins slave base
#
# VERSION               0.0.1

FROM       ubuntu:trusty
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

RUN useradd -d /opt/jenkins -m -s /bin/bash jenkins

ADD files/mirror.local /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386 && apt-get update && apt-get -q -y upgrade

# Install basic tools
RUN apt-get -q -y install ssh sudo lynx links curl wget sysstat logtail vim build-essential zip unzip moreutils apt-transport-https locales

# Update default locale
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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
RUN ln -s /opt/build/tools/apache-maven-3.0.5 /opt/build/tools/maven3.0
RUN rm /tmp/maven-3.0.5.tar.gz

RUN wget -O /tmp/maven-3.1.1.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-3.1.1-bin.tar.gz
RUN tar xzf /tmp/maven-3.1.1.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-3.1.1 /opt/build/tools/maven-3.1
RUN ln -s /opt/build/tools/apache-maven-3.1.1 /opt/build/tools/maven3.1
RUN rm /tmp/maven-3.1.1.tar.gz

RUN wget -O /tmp/maven-3.2.3.tar.gz http://www.us.apache.org/dist/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
RUN tar xzf /tmp/maven-3.2.3.tar.gz -C /opt/build/tools
RUN ln -s /opt/build/tools/apache-maven-3.2.3 /opt/build/tools/maven-3.2
RUN ln -s /opt/build/tools/apache-maven-3.2.3 /opt/build/tools/maven3.2
RUN rm /tmp/maven-3.2.3.tar.gz

RUN ln -s /opt/build/tools/maven-3.2/bin/mvn /usr/bin/mvn

## Gradle
RUN wget -O /tmp/gradle.zip http://services.gradle.org/distributions/gradle-1.6-bin.zip
RUN unzip -d /opt/build/tools /tmp/gradle.zip
RUN ln -s /opt/build/tools/gradle-1.6 /opt/build/tools/gradle
RUN ln -s /opt/build/tools/gradle/bin/gradle /usr/bin/gradle
RUN rm /tmp/gradle.zip


# Install other misc dependencies
RUN apt-get -q -y install linkchecker s3cmd python-dev python-setuptools python-lxml python-webunit python-docutils python-reportlab python-pypdf gnuplot python-pip tcpwatch-httpproxy dpkg-dev devscripts debhelper cdbs gnupg redis-server
RUN easy_install -f http://funkload.nuxeo.org/snapshots/ -U funkload
#RUN echo "deb https://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
#RUN apt-get update
#RUN apt-get -q -y install lxc-docker

# Install converters
RUN apt-get -q -y install imagemagick ffmpeg2theora ufraw poppler-utils libreoffice libwpd-tools gimp
RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
ENV BUILD_YASM true
RUN cd ffmpeg-nuxeo && ./build-all.sh true

# Install Android SDK
RUN apt-get -q -y install libstdc++6:i386 lib32z1 expect
RUN curl -L -Oandroid-sdk-installer https://raw.githubusercontent.com/embarkmobile/android-sdk-installer/f11ccc15b6f9d43eb1e7a61d3bc0939cc3827545/android-sdk-installer
RUN perl -p -i -E 's/-3L/-L/g' android-sdk-installer
ENV ANDROID_COMPONENTS platform-tools,build-tools-18.1.0,android-17,sysimg-17,android-16,sysimg-16,android-8,sysimg-8,addon-google_apis-google-16,extra-android-support,extra-google-google_play_services,extra-google-m2repository,extra-android-m2repository
RUN bash android-sdk-installer --install=$ANDROID_COMPONENTS --dir=/opt/build/tools/android-installer-broken
RUN chown -R jenkins /opt/build/tools/android-installer-broken/*
RUN cp -Rp /opt/build/tools/android-installer-broken /opt/build/tools/android-installer
RUN rm -rf /opt/build/tools/android-installer-broken
RUN perl -p -i -e 's/android-installer-broken/android-installer/g' /opt/build/tools/android-installer/env
RUN ln -s /opt/build/tools/android-installer/android-sdk-linux /opt/build/tools/android
RUN ln -s /opt/build/tools/android/platform-tools/adb /opt/build/tools/android/tools/adb
RUN ln -s /opt/build/tools/android/build-tools/18.1.0/aapt /opt/build/tools/android/platform-tools/aapt
RUN rm android-sdk-installer
# Initialize maven repository with android artifacts
RUN su jenkins -c 'cd /opt/jenkins && git clone https://github.com/mosabua/maven-android-sdk-deployer.git'
RUN su jenkins -c 'cd /opt/jenkins/maven-android-sdk-deployer && source /opt/build/tools/android-installer/env && mvn install -P4.1'

# Add Oracle JDBC drivers
ADD tmpfiles/m2repo/com /opt/jenkins/.m2/repository/com
RUN chown -R jenkins /opt/jenkins/.m2/repository/com

# Install nodejs and friends
RUN mkdir -p /usr/local/src
RUN wget -O/usr/local/src/node-v0.10.32.tar.gz http://nodejs.org/dist/v0.10.32/node-v0.10.32.tar.gz
RUN cd /usr/local/src && tar xzf node-v0.10.32.tar.gz
RUN cd /usr/local/src/node-v0.10.32 && ./configure && make && make install
RUN npm install -g yo grunt-cli gulp bower

# Install Java 6
RUN wget -q -O/tmp/jdk6.bin "http://javadl.sun.com/webapps/download/AutoDL?BundleId=63975"
WORKDIR /usr/lib/jvm
RUN sh /tmp/jdk6.bin -noregister && ln -s /usr/lib/jvm/jdk1.6.0_33 /usr/lib/jvm/java-6-sun && rm /tmp/jdk6.bin

# Install Java 8
RUN wget -q -O/tmp/jdk-8-linux-x64.tgz --no-check-certificate --header 'Cookie: oraclelicense=accept-securebackup-cookie' 'http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz'
WORKDIR /usr/lib/jvm
RUN tar xzf /tmp/jdk-8-linux-x64.tgz && ln -s /usr/lib/jvm/jdk1.8.0_25 /usr/lib/jvm/java-8 && rm /tmp/jdk-8-linux-x64.tgz

