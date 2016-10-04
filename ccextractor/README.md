This builds a deb package of CCExtractor from the sources at https://github.com/CCExtractor/ccextractor inside a docker container.

This version builds a package for Ubuntu 16.04 (xenial), but you can replace "ubuntu:xenial" in the Dockerfile by "ubuntu:trusty" or "debian:jessie" to build for Ubuntu 14.04 or Debian 8 instead.

The resulting deb package will be in a "packages" directory.

