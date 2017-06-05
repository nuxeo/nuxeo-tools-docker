FROM ubuntu:xenial

RUN perl -p -i -e 's,archive.ubuntu.com,ubuntu.mirrors.ovh.net/ftp.ubuntu.com,g' /etc/apt/sources.list
RUN sed -i 's,^deb-src,#deb-src,g' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl
RUN echo "deb http://apt.nuxeo.org/ xenial releases" > /etc/apt/sources.list.d/nuxeo.list
RUN curl http://apt.nuxeo.org/nuxeo.key | apt-key add -

RUN apt-get update && apt-get install -y \
    unzip python python-requests python-lxml \
    imagemagick ufraw ffmpeg2theora ffmpeg-nuxeo \
    poppler-utils exiftool libwpd-tools \
    openjdk-8-jdk libreoffice redis-tools \
    postgresql-client screen netcat \
    openjdk-8-jdk

ADD http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip /tmp/fakeSMTP-latest.zip
RUN mkdir /tmp/fakesmtp && \
    unzip -q -d /tmp/fakesmtp /tmp/fakeSMTP-latest.zip && \
    mv /tmp/fakesmtp/$(/bin/ls -1 /tmp/fakesmtp) /usr/lib/fakeSMTP.jar && \
    rm -rf /tmp/fakesmtp && \
    rm /tmp/fakeSMTP-latest.zip

RUN useradd -u 1005 -d /opt/nuxeo -m -s /bin/bash nuxeo

ADD files/get-nuxeo-distribution /usr/bin/get-nuxeo-distribution
ADD files/nuxeoctl /usr/bin/nuxeoctl
RUN chmod 0755 /usr/bin/get-nuxeo-distribution /usr/bin/nuxeoctl

EXPOSE 8080

ADD files/deploy.sh /deploy.sh
RUN chmod 0755 /deploy.sh
CMD ["bash", "/deploy.sh"]

