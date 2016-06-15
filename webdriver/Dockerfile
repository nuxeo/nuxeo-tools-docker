# Image with multiple firefox/and selenium versions
# selectable through env variables

FROM       phusion/baseimage:0.9.18
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -q -y dist-upgrade && \
    apt-get -q -y install bzip2 openjdk-7-jdk xvfb fluxbox wget && \
    apt-get clean

RUN mkdir /etc/service/xvfb
ADD files/xvfb /etc/service/xvfb/run
RUN chmod +x /etc/service/xvfb/run

RUN mkdir /etc/service/fluxbox
ADD files/fluxbox /etc/service/fluxbox/run
RUN chmod +x /etc/service/fluxbox/run

RUN touch /etc/service/cron/down

RUN wget -O/tmp/firefox24.tar.bz2 https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/24.0/linux-x86_64/en-US/firefox-24.0.tar.bz2 && \
    cd /opt && \
    tar xjf /tmp/firefox24.tar.bz2 && \
    rm /tmp/firefox24.tar.bz2 && \
    mv firefox firefox-24

RUN wget -O/tmp/firefox26.tar.bz2 https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/26.0/linux-x86_64/en-US/firefox-26.0.tar.bz2 && \
    cd /opt && \
    tar xjf /tmp/firefox26.tar.bz2 && \
    rm /tmp/firefox26.tar.bz2 && \
    mv firefox firefox-26

RUN wget -O/tmp/firefox42.tar.bz2 https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/42.0/linux-x86_64/en-US/firefox-42.0.tar.bz2 && \
    cd /opt && \
    tar xjf /tmp/firefox42.tar.bz2 && \
    rm /tmp/firefox42.tar.bz2 && \
    mv firefox firefox-42

RUN wget -O/opt/selenium-server-standalone-2.39.0.jar https://maven-eu.nuxeo.org/nexus/service/local/repositories/jenkins/content/org/seleniumhq/selenium/selenium-server-standalone/2.39.0/selenium-server-standalone-2.39.0.jar
RUN wget -O/opt/selenium-server-standalone-2.45.0.jar https://maven-eu.nuxeo.org/nexus/service/local/repositories/jenkins/content/org/seleniumhq/selenium/selenium-server-standalone/2.45.0/selenium-server-standalone-2.45.0.jar
RUN wget -O/opt/selenium-server-standalone-2.53.0.jar https://maven-eu.nuxeo.org/nexus/service/local/repositories/jenkins/content/org/seleniumhq/selenium/selenium-server-standalone/2.53.0/selenium-server-standalone-2.53.0.jar

ADD files/10_envsetup.sh /etc/my_init.d/10_envsetup.sh
RUN chmod +x /etc/my_init.d/10_envsetup.sh

RUN mkdir /etc/service/webdriver
ADD files/webdriver /etc/service/webdriver/run
RUN chmod +x /etc/service/webdriver/run

EXPOSE 4444

