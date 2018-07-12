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
##     Frantz FISCHER <ffischer@nuxeo.com>

FROM openjdk:8u151-jdk-slim

LABEL maintainer="Nuxeo Packagers <packagers+docker-shibboleth-idp-2@nuxeo.com>" \
      version="1.0.3" \
      scm-ref="PIPELINE-SCM-VALUE" \
      scm-url="https://github.com/nuxeo/nuxeo-tools-docker" \
      description="A Shibboleth Identity Provider version 2 with users coming from an LDAP repository"

ENV IDP_HOST="idp.shibboleth.com" \
    IDP_HOME="/opt/shibboleth-idp" \
    IDP_STORE_PASS="/opt/shibboleth-idp" \
    IDP_TOMCAT_HOME="/opt/tomcat-shib-idp" \
    IDP_TOMCAT_HTTP_PORT="7080" \
    IDP_TOMCAT_HTTPS_PORT="7443" \
    IDP_TOMCAT_AJP_PORT="7009" \
    IDP_TOMCAT_SHUTDOWN_PORT="7005" \
    IDP_SSL_ENABLED="true" \
    IDP_INSTALL_FOLDER="/tmp/shibboleth-identityprovider" \
    LDAP_SSL_ENABLED="false" \
    SHIB_LDAP_BASE_DN="dc=nuxeo,dc=com" \
    SHIB_LDAP_ADMIN_BIND_PASSWORD="password" \
    TOMCAT_VERSION="8.0.48" \
    IDP_VERSION="2.4.5" \
    TOMCAT_SHA1="d2446c127c9b11f88def11e542af98998071d91d" \
    TOMCAT_USER="tomcat" \
    TOMCAT_GROUP="tomcat" \
    IDP_SHA1="14cfb67aac68c521dd2d30e41febba13d4a97b73" \
    SP_SSL_ENABLED="true" \
    SP_HOST="sp.shibboleth.com" \
    WAIT_FOR_SP_AND_REG="false" \
    SP_TYPE="Shibboleth" \
    ENCRYPT_SAML_ASSERTIONS="true"

ENV TOMCAT_ARCHIVE="apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    IDP_ARCHIVE="shibboleth-identityprovider-${IDP_VERSION}-bin.tar.gz" \
    SHIB_LDAP_USERS_BASE_DN="ou=people,${SHIB_LDAP_BASE_DN}" \
    SHIB_LDAP_ADMIN_BIND_DN="cn=admin,${SHIB_LDAP_BASE_DN}" \
    LDAP_HOST="ldap.shibboleth.com" \
    PATH="${IDP_TOMCAT_HOME}/bin:$PATH"

ADD files /tmp/

RUN apt-get update && apt-get install patch wget -y; \
    set -ex; \
    mkdir -p "${IDP_TOMCAT_HOME}"; \
    groupadd -f ${TOMCAT_GROUP}; \
    useradd -s /bin/false -g ${TOMCAT_GROUP} -d "${IDP_TOMCAT_HOME}" ${TOMCAT_USER}; \
    cd /tmp; \
    wget "https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/${TOMCAT_ARCHIVE}"; \
    wget "https://shibboleth.net/downloads/identity-provider/${IDP_VERSION}/${IDP_ARCHIVE}"; \
    echo "${TOMCAT_SHA1} *${TOMCAT_ARCHIVE}" | sha1sum -c -; \
    echo "${IDP_SHA1} *${IDP_ARCHIVE}" | sha1sum -c -; \
    tar xzf "${TOMCAT_ARCHIVE}" -C "${IDP_TOMCAT_HOME}" --strip-components=1; \
    rm "${TOMCAT_ARCHIVE}"; \
    cp /tmp/conf/tomcat-users.xml "${IDP_TOMCAT_HOME}"/conf/tomcat-users.xml; \
    mkdir -p "${IDP_INSTALL_FOLDER}"; \
    tar xzf "${IDP_ARCHIVE}" -C "${IDP_INSTALL_FOLDER}" --strip-components=1; \
    rm "${IDP_ARCHIVE}"; \
    chown ${TOMCAT_USER}:${TOMCAT_GROUP} ${IDP_INSTALL_FOLDER} -R; \
    chown ${TOMCAT_USER}:${TOMCAT_GROUP} /opt -R; \
    chown ${TOMCAT_USER}:${TOMCAT_GROUP} /tmp/conf -R; \
    chown ${TOMCAT_USER}:${TOMCAT_GROUP} /tmp/patches -R

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR "${IDP_TOMCAT_HOME}"/bin
USER ${TOMCAT_USER}