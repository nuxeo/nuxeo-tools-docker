#!/bin/bash -e

MAXWAIT=300 # 5 minutes

# Wait for nuxeo1 and nuxeo2 to be up

time1=$(date +"%s")
until [ "$(curl -m 5 -s http://nuxeo1:8080/nuxeo/runningstatus?info=started)" == "true" ] && \
      [ "$(curl -m 5 -s http://nuxeo2:8080/nuxeo/runningstatus?info=started)" == "true" ]; do
    time2=$(date +"%s")
    delta=$((time2 - time1))
    if [ $delta -gt $MAXWAIT ]; then
        echo "Max wait time exceeded - aborting."
        exit 1
    else
        echo "Waiting for Nuxeo nodes to become available..."
        sleep 10
    fi
done

echo "Nuxeo nodes are available, starting Apache."

# Start Apache

mkdir -p /deploy /share /logs
chmod 0777 /deploy /share /logs
umask 0000
mkdir -p /logs/apache
chown www-data:www-data /logs/apache

mkdir -p $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR
chown $APACHE_RUN_USER:$APACHE_RUN_GROUP $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR

/usr/sbin/apache2 -D FOREGROUND
