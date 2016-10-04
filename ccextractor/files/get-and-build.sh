#!/bin/bash -e

wget -O master.zip https://codeload.github.com/CCExtractor/ccextractor/zip/master
unzip master.zip

cd ccextractor-master/linux
./build

DATE=$(date +"%Y%m%d")
checkinstall --pkgname=ccextractor-nuxeo --pkgversion="0.0.1-$DATE-01" \
    --maintainer="'Nuxeo Packagers <packagers@nuxeo.com>'" \
    --requires="libtesseract3,libcurl3" \
    --backup=no --deldoc=yes --deldesc=yes --fstrans=no --default \
    cp ccextractor /usr/local/bin

mkdir -p /packages
chmod 0777 /packages
cp ccextractor-nuxeo_0.0.1-$DATE-01-1_amd64.deb /packages/
chmod 0666 /packages/*.deb

