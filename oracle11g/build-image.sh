#!/bin/bash

cd $(dirname $0)

echo
echo "*** Building image with prerequisites ***"
echo

docker build -t nuxeo/oracle11g-preinst .

echo
echo "*** Running installation in container ***"
echo

docker run --privileged -h oracle11g -v $(pwd)/install_files:/tmpinstall:rw -t -i nuxeo/oracle11g-preinst /root/install.sh

echo
echo "*** Creating new image from container ***"
echo

cid=$(docker ps -a | grep 'nuxeo/oracle11g-preinst' | awk '{print $1}')
docker commit -c 'EXPOSE 1521' -c 'CMD ["/start.sh"]' $cid nuxeo/oracle11g
docker rm $cid

