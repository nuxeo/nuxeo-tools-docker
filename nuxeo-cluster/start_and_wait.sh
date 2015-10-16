#!/bin/bash -e

MAXWAIT=300 # 5 minutes

cd $(dirname $0)
./cleanup.sh
mkdir -p deploy share logs
docker-compose up -d

time1=$(date +"%s")
until curl -m 5 -o /dev/null -s http://localhost:8080/; do
    time2=$(date +"%s")
    delta=$((time2 - time1))
    if [ $delta -gt $MAXWAIT ]; then
        echo "Max wait time exceeded - aborting."
        docker-compose kill
        docker-compose rm -f
        exit 1
    else
        sleep 5
    fi
done

echo "Ready!"

