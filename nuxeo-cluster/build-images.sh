#!/bin/bash -e

cd $(dirname $0)
./cleanup.sh
docker-compose build

