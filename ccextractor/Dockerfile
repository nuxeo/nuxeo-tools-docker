FROM ubuntu:bionic

RUN apt-get update
RUN apt-get -q -y install wget unzip cmake libcurl3-openssl-dev libtesseract-dev libleptonica-dev checkinstall

COPY files/get-and-build.sh get-and-build.sh
RUN chmod +x get-and-build.sh

ENTRYPOINT ./get-and-build.sh

