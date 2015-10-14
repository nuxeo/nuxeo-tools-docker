#!/bin/bash -e

cd $(dirname $0)
docker-compose kill
docker-compose rm -f
rm -rf logs share

