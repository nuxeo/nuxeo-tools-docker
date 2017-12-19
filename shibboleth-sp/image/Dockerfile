##
## (C) Copyright 2017 Nuxeo (http://nuxeo.com/) and others.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Contributors:
##     Funsho David

FROM centos:7

LABEL maintainer="Nuxeo Packagers <packagers+docker-shibboleth-sp@nuxeo.com>"
LABEL version="1.0.0"
LABEL scm-ref="PIPELINE-SCM-VALUE"
LABEL scm-url="https://github.com/nuxeo/nuxeo-tools-docker"
LABEL description="A Shibboleth service provider image"

RUN yum -y update \
    && yum -y install wget mod_ssl \
    && wget http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -P /etc/yum.repos.d \
    && yum -y install httpd shibboleth.x86_64 \
    && yum -y clean all

COPY bin/httpd-shibd-foreground /usr/local/bin/

ENV SP_HOST="sp.shibboleth.com" \
    SP_PORT=8080 \
    IDP_HOST="idp.shibboleth.com" \
    NUXEO_HOST="nuxeo.shibboleth.com" \
    IDP_PORT=7443 \
    SP_APACHE_PORT=443 \
    ANONYMOUS_LOGIN=false

ENV SP_URL http://$NUXEO_HOST:$SP_PORT/nuxeo/

COPY conf/sp.shibboleth.com.conf /etc/httpd/conf.d/
COPY conf/shibboleth2.xml /etc/shibboleth/
WORKDIR /etc/shibboleth/

RUN test -d /var/run/lock || mkdir -p /var/run/lock \
    && test -d /var/lock/subsys/ || mkdir -p /var/lock/subsys/ \
    && chmod +x /etc/shibboleth/shibd-redhat \
    && chmod +x /usr/local/bin/httpd-shibd-foreground \
    && echo $'export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH\n'\
          > /etc/sysconfig/shibd \
    && chmod +x /etc/sysconfig/shibd \
    && openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/shibboleth/$SP_HOST.key -out /etc/shibboleth/$SP_HOST.crt -subj "/CN=$SP_HOST" \
    && sed -i "s/SHIBBOLETH_IDP_HOSTNAME/$IDP_HOST/g" /etc/shibboleth/shibboleth2.xml \
    && sed -i "s/SHIBBOLETH_IDP_PORT/$IDP_PORT/g" /etc/shibboleth/shibboleth2.xml \
    && sed -i "s/SHIBBOLETH_SP_HOSTNAME/$SP_HOST/g" /etc/shibboleth/shibboleth2.xml \
    && sed -i "s/SHIBBOLETH_SP_PORT/$SP_APACHE_PORT/g" /etc/shibboleth/shibboleth2.xml \
    && sed -i '/<\/Attributes>/s/^/    <Attribute name="urn:oid:0.9.2342.19200300.100.1.1" id="uid"\/>\n    <Attribute name="urn:oid:0.9.2342.19200300.100.1.3" id="mail"\/>\n    <Attribute name="urn:oid:2.5.4.3" id="cn"\/>\n    <Attribute name="urn:oid:2.5.4.4" id="sn"\/>\n    <Attribute name="urn:oid:2.5.4.42" id="givenName"\/>\n/' /etc/shibboleth/attribute-map.xml

EXPOSE 443

CMD ["httpd-shibd-foreground"]
