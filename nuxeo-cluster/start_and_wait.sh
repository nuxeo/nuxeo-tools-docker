#!/bin/bash -e

cd $(dirname $0)
./cleanup.sh
mkdir share logs
docker-compose build
docker-compose up -d
until curl -m 5 -o /dev/null -s http://localhost:8080/; do
    sleep 5
done

