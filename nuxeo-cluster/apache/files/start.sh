#!/bin/bash -e

NUM_INSTANCES=2
MAXWAIT=600 # 10 minutes

# Wait for Redis

until nc -q 1 redis 6379 < /dev/null; do
    sleep 1
done

# Wait for nuxeo instances to be up

time1=$(date +"%s")
while true; do
    for i in $(redis-cli --csv -h redis smembers nuxeo-starting | tr ',' ' ' | tr -d '"'); do
        if [ "$(curl -m 5 -s http://$i:8080/nuxeo/runningstatus?info=started)" == "true" ]; then
            redis-cli --csv -h redis sadd nuxeo-started $i > /dev/null
            redis-cli --csv -h redis srem nuxeo-starting $i > /dev/null
            redis-cli --csv -h redis del nuxeo-start-lock > /dev/null
        fi
    done
    if [ "$(redis-cli --csv -h redis scard nuxeo-started)" == "${NUM_INSTANCES}" ]; then
        break
    fi
    time2=$(date +"%s")
    delta=$((time2 - time1))
    if [ $delta -gt $MAXWAIT ]; then
        echo "Max wait time exceeded - aborting."
        exit 1
    else
        starting=$(redis-cli --csv -h redis smembers nuxeo-starting | tr -d '"')
        if [ "$starting" == "" ]; then
            starting="none"
        fi
        started=$(redis-cli --csv -h redis smembers nuxeo-started | tr -d '"')
        if [ "$started" == "" ]; then
            started="none"
        fi
        printf "Waiting for Nuxeo nodes to become available... (starting: %s - started: %s)\n" "$starting" "$started"
        sleep 10
    fi
done


started=$(redis-cli --csv -h redis smembers nuxeo-started | tr -d '"')
printf "Nuxeo nodes (%s) are available, starting Apache.\n" "$started"

# Start Apache

mkdir -p /deploy /share /logs
chmod 0777 /deploy /share /logs
umask 0000
mkdir -p /logs/apache
chown www-data:www-data /logs/apache

mkdir -p $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR
chown $APACHE_RUN_USER:$APACHE_RUN_GROUP $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR

/usr/sbin/apache2 -D FOREGROUND
