FROM ubuntu:trusty

RUN perl -p -i -e 's,archive.ubuntu.com,ubuntu.mirrors.ovh.net/ftp.ubuntu.com,g' /etc/apt/sources.list
RUN sed -i 's,^deb-src,#deb-src,g' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl
RUN echo "deb http://apt.nuxeo.org/ trusty releases" > /etc/apt/sources.list.d/nuxeo.list
RUN curl http://apt.nuxeo.org/nuxeo.key | apt-key add -

RUN apt-get update && apt-get install -y \
    unzip python python-requests python-lxml \
    imagemagick ufraw ffmpeg2theora ffmpeg-nuxeo \
    poppler-utils exiftool libwpd-tools \
    openjdk-7-jdk libreoffice redis-tools

RUN mkdir -p /usr/lib/jvm && \
    curl -o/tmp/jdk-8-linux-x64.tgz -L --insecure --header 'Cookie: oraclelicense=accept-securebackup-cookie' 'http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz' && \
    tar xzf /tmp/jdk-8-linux-x64.tgz -C /usr/lib/jvm && \
    rm /tmp/jdk-8-linux-x64.tgz && \
    ln -s /usr/lib/jvm/jdk1.8.0_40 /usr/lib/jvm/java-8 && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8/jre/bin/java 1081 && \
    update-alternatives --set java /usr/lib/jvm/java-8/jre/bin/java

RUN useradd -u 1005 -d /opt/nuxeo -m -s /bin/bash nuxeo

ADD files/get-nuxeo-distribution /usr/bin/get-nuxeo-distribution
ADD files/nuxeoctl /usr/bin/nuxeoctl
RUN chmod 0755 /usr/bin/get-nuxeo-distribution /usr/bin/nuxeoctl

EXPOSE 8080

ADD files/deploy.sh /deploy.sh
RUN chmod 0755 /deploy.sh
CMD ["bash", "/deploy.sh"]

