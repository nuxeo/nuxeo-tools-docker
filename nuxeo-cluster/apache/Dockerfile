FROM ubuntu:trusty

RUN perl -p -i -e 's,archive.ubuntu.com,ubuntu.mirrors.ovh.net/ftp.ubuntu.com,g' /etc/apt/sources.list
RUN sed -i 's,^deb-src,#deb-src,g' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apache2 curl redis-tools
RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers
RUN printf "\nServerName localhost\n" >> /etc/apache2/apache2.conf

RUN rm -f /etc/apache2/sites-enabled/*
ADD files/proxy.conf /etc/apache2/sites-available/proxy.conf
RUN a2ensite proxy.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

EXPOSE 80

ADD files/start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "/start.sh"]

