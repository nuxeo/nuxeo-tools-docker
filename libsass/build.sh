#!/bin/bash -e

RELEASE="3.3.6"

git clone https://github.com/sass/libsass.git libsass
git -C libsass checkout $RELEASE

git clone https://github.com/sass/sassc.git libsass/sassc
git -C libsass/sassc checkout $RELEASE

cd libsass

autoreconf --force --install
./configure --disable-tests --enable-shared --prefix=/usr
make

echo "libsass - Nuxeo version" > description-pak
checkinstall --pkgname=libsass-nuxeo --pkgversion="$RELEASE" \
    --conflicts=libsass0,libsass-dev \
    --maintainer="'Nuxeo Packagers <packagers@nuxeo.com>'" \
    --backup=no --nodoc --deldesc=yes --fstrans=no --default

mkdir -p /packages
chmod 0777 /packages
cp libsass-nuxeo_$RELEASE-1_amd64.deb /packages/
chmod 0666 /packages/libsass-nuxeo_$RELEASE-1_amd64.deb

