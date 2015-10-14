#!/bin/bash -e

SLEEP=10
MAXSLEEPS=30 # 5 minutes

# Wait for nuxeo1 and nuxeo2 to be up

sleeps=0
while [ $sleeps -lt $MAXSLEEPS ]; do
    if [ "$(curl -m 5 -s http://nuxeo1:8080/nuxeo/runningstatus?info=started)" == "true" ] && \
       [ "$(curl -m 5 -s http://nuxeo2:8080/nuxeo/runningstatus?info=started)" == "true" ]; then
        break
    else
        echo "Waiting for Nuxeo nodes to become available..."
        sleeps=$((sleeps+1))
        sleep $SLEEP
    fi
done

echo "Nuxeo nodes are available, starting Apache."

# Start Apache

mkdir -p $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR
chown $APACHE_RUN_USER:$APACHE_RUN_GROUP $APACHE_LOG_DIR $APACHE_RUN_DIR $APACHE_LOCK_DIR

/usr/sbin/apache2 -D FOREGROUND
