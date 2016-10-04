#!/bin/bash -e

cd $(dirname $0)

docker build -t nuxeo/ccextractor-deb-pkg .
docker run --rm -v $(pwd)/packages:/packages nuxeo/ccextractor-deb-pkg

