#!/bin/bash

cd $(dirname $0)

git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
cd ffmpeg-nuxeo

export BUILD_YASM=true
./build-all.sh false
mkdir -p /packages
chmod 0777 /packages
find ffmpeg* -type f -name '*.deb' -exec cp {} /packages/ \;
chmod 0666 /packages/*.deb

