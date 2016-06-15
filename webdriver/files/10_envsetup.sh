#!/bin/bash -e


echo ":1" > /etc/container_environment/DISPLAY
echo "DISPLAY=:1" >>  /etc/environment


FF=${FFVERSION:-42}
SEL=${SELVERSION:-2.53.0}

if [ ! -d /opt/firefox-${FF} ]; then
    echo "Firefox version ${FF} is not available in this image."
    exit 1
fi
echo "Using Firefox ${FF}."
ln -s /opt/firefox-${FF}/firefox /usr/bin/firefox

if [ ! -f /opt/selenium-server-standalone-${SEL}.jar ]; then
    echo "Selenium version ${SEL} is not available in this image."
    exit 1
fi
echo "Using Selenium ${SEL}."
ln -s /opt/selenium-server-standalone-${SEL}.jar /opt/selenium-server-standalone.jar

