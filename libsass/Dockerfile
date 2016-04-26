FROM ubuntu:trusty

RUN apt-get update && apt-get -y install build-essential automake libtool checkinstall git

RUN mkdir -p /usr/local/src
COPY build.sh /usr/local/src/build.sh
RUN chmod 0755 /usr/local/src/build.sh

ENTRYPOINT /usr/local/src/build.sh

