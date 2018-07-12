#!/bin/sh -e

startAndWaitForIdP() {
  "${IDP_TOMCAT_HOME}"/bin/startup.sh

  echo "Waiting for Shibboleth IdP server log file to be created..."
  until [ -f "${IDP_HOME}"/logs/idp-process.log ]; do
    echo "[$(date "+%H:%M:%S")] Shibboleth IdP server log file does not exists yet - sleeping"
    sleep 2
  done
}

TMP_PATCHES_FOLDER=/tmp/patches
TMP_CONF_FOLDER=/tmp/conf

SP_URL_PROTOCOL="$(if [ "${SP_SSL_ENABLED}" = "true" ]; then echo "https"; else echo "http"; fi)"
if [ "${SP_TYPE}" = "Shibboleth" ]; then
  SP_METADATA_PATH="Shibboleth.sso/Metadata"
elif [ "${SP_TYPE}" = "Nuxeo" ]; then
  SP_METADATA_PATH="nuxeo/saml/metadata"
else
  echo "ERROR: unknown SP type [${SP_TYPE}]"
  exit 1
fi
SP_URL="${SP_URL_PROTOCOL}://${SP_HOST}/${SP_METADATA_PATH}"

echo "SP metadata URL is ${SP_URL}"

cd "${IDP_INSTALL_FOLDER}"
patch -p0 < "${TMP_PATCHES_FOLDER}"/build.xml.patch
sed -i "s/SHIBBOLETH_IDP_HOME/$(echo "${IDP_HOME}" | sed 's/\//\\\//g')/" src/installer/resources/build.xml
sed -i "s/SHIBBOLETH_IDP_KEYSTORE_PASSWORD/$(echo "${IDP_STORE_PASS}" | sed 's/\//\\\//g')/" src/installer/resources/build.xml
sed -i "s/SHIBBOLETH_IDP_HOSTNAME/${IDP_HOST}/" src/installer/resources/build.xml
sed -i "s/SHIBBOLETH_IDP_PORT/$(if [ "${IDP_SSL_ENABLED}" = "true" ]; then echo "${IDP_TOMCAT_HTTPS_PORT}"; else echo "${IDP_TOMCAT_HTTP_PORT}"; fi)/" src/installer/resources/build.xml
sed -i "s/SHIBBOLETH_IDP_PROTOCOL/$(if [ "${IDP_SSL_ENABLED}" = "true" ]; then echo "https"; else echo "http"; fi)/" src/installer/resources/build.xml
sed -i "s/8443/${IDP_TOMCAT_HTTPS_PORT}/g" src/installer/resources/metadata-tmpl/idp-metadata.xml
sed -i "s/\/\$IDP_HOSTNAME\$\//\/\$IDP_HOSTNAME\$:${IDP_TOMCAT_HTTPS_PORT}\//g" src/installer/resources/metadata-tmpl/idp-metadata.xml

./install.sh

cp "${TMP_CONF_FOLDER}"/login.config "${IDP_HOME}"/conf/login.config
sed -i "s/\${LDAP_HOST}/${LDAP_HOST}/g" "${IDP_HOME}"/conf/login.config
sed -i "s/\${SHIB_LDAP_USERS_BASE_DN}/${SHIB_LDAP_USERS_BASE_DN}/g" "${IDP_HOME}"/conf/login.config
sed -i "s/\${SHIB_LDAP_ADMIN_BIND_DN}/${SHIB_LDAP_ADMIN_BIND_DN}/g" "${IDP_HOME}"/conf/login.config
sed -i "s/\${SHIB_LDAP_ADMIN_BIND_PASSWORD}/${SHIB_LDAP_ADMIN_BIND_PASSWORD}/g" "${IDP_HOME}"/conf/login.config
sed -i "s/\${SSL_FLAG}/${LDAP_SSL_ENABLED}/g" "${IDP_HOME}"/conf/login.config
sed -i "s/\${TLS_FLAG}/${LDAP_SSL_ENABLED}/g" "${IDP_HOME}"/conf/login.config

sed -i 's/<logger name="edu.internet2.middleware.shibboleth"\s*level=".*"\/>/<logger name="edu.internet2.middleware.shibboleth" level="ALL"\/>/' "${IDP_HOME}"/conf/logging.xml
sed -i 's/<logger name="org.opensaml"\s*level=".*"\/>/<logger name="org.opensaml" level="ALL"\/>/' "${IDP_HOME}"/conf/logging.xml
sed -i 's/<logger name="edu.vt.middleware.ldap"\s*level=".*"\/>/<logger name="edu.vt.middleware.ldap" level="ALL"\/>/' "${IDP_HOME}"/conf/logging.xml

sed -i '/<Connector port="8080"/s/^/<Connector protocol="org.apache.coyote.http11.Http11NioProtocol" port="8443"\n    maxThreads="200" scheme="https" secure="true" SSLEnabled="true" keystoreFile="'"$(echo "${IDP_HOME}" | sed 's/\//\\\//g')"'\/credentials\/idp.jks"\n    keystorePass="'"$(echo "${IDP_STORE_PASS}" | sed 's/\//\\\//g')"'" clientAuth="false" sslProtocol="TLS" \/>\n\n/' "${IDP_TOMCAT_HOME}"/conf/server.xml
sed -i "s/8005/${IDP_TOMCAT_SHUTDOWN_PORT}/g" "${IDP_TOMCAT_HOME}"/conf/server.xml
sed -i "s/8009/${IDP_TOMCAT_AJP_PORT}/g" "${IDP_TOMCAT_HOME}"/conf/server.xml
sed -i "s/8080/${IDP_TOMCAT_HTTP_PORT}/g" "${IDP_TOMCAT_HOME}"/conf/server.xml
sed -i "s/8443/${IDP_TOMCAT_HTTPS_PORT}/g" "${IDP_TOMCAT_HOME}"/conf/server.xml

mkdir -p "${IDP_TOMCAT_HOME}"/conf/Catalina/localhost
cp "${TMP_CONF_FOLDER}"/idp.xml "${IDP_TOMCAT_HOME}"/conf/Catalina/localhost/idp.xml
sed -i "s/\${IDP_HOME}/$(echo "${IDP_HOME}" | sed 's/\//\\\//g')/g" "${IDP_TOMCAT_HOME}"/conf/Catalina/localhost/idp.xml

cd "${IDP_HOME}"
patch -p0 < "${TMP_PATCHES_FOLDER}"/idphandler.patch
sed -i "s/SHIBBOLETH_IDP_HOME/$(echo "${IDP_HOME}" | sed 's/\//\\\//g')/" "${IDP_HOME}"/conf/handler.xml

# Adding uid and mail to the attributes, set up LDAP configuration
cp "${TMP_PATCHES_FOLDER}"/idpattribute-resolver.xml "${IDP_HOME}"/conf/attribute-resolver.xml
sed -i "s/LDAP_HOST/${LDAP_HOST}/g;s/SHIB_LDAP_USERS_BASE_DN/${SHIB_LDAP_USERS_BASE_DN}/g;s/SHIB_LDAP_ADMIN_BIND_DN/${SHIB_LDAP_ADMIN_BIND_DN}/;s/SHIB_LDAP_ADMIN_BIND_PASSWORD/${SHIB_LDAP_ADMIN_BIND_PASSWORD}/" "${IDP_HOME}"/conf/attribute-resolver.xml
# Adding uid and mail to the responses else they are not available
cd "${IDP_HOME}"/conf
patch < "${TMP_PATCHES_FOLDER}"/attribute-filter.xml.patch

if [ "${ENCRYPT_SAML_ASSERTIONS}" = "true" ]; then
  echo "SAML assertions encryption is enabled."
elif [ "${ENCRYPT_SAML_ASSERTIONS}" = "false" ]; then
  echo "SAML assertions encryption is disabled."
  sed -i "s/encryptAssertions=\"conditional\"/encryptAssertions=\"never\"/" "${IDP_HOME}"/conf/relying-party.xml
else
  echo "ERROR: unknown ENCRYPT_SAML_ASSERTIONS value [${ENCRYPT_SAML_ASSERTIONS}]"
  exit 1
fi

# Removing unneeded folders
rm -rf "${IDP_INSTALL_FOLDER}"
rm -rf "${TMP_CONF_FOLDER}"
rm -rf "${TMP_PATCHES_FOLDER}"

startAndWaitForIdP

if [ "${WAIT_FOR_SP_AND_REG}" = "true" ]; then
  echo "Waiting for Shibboleth SP server to retrieve the metadata file..."
  until grep -q '"GET /idp/shibboleth HTTP/1.1" 200' "${IDP_TOMCAT_HOME}"/logs/localhost_access_log.*; do
    echo "[$(date "+%H:%M:%S")] Metadata file not yet retrieved - sleeping"
    sleep 2
  done
  "${IDP_TOMCAT_HOME}"/bin/shutdown.sh

  sed -i '/maxRefreshDelay="P1D" \/>/s/$/\n\n        <MetadataProvider xsi:type="FilesystemMetadataProvider"\
                                     xmlns="urn:mace:shibboleth:2.0:metadata"\
                                     id="URLMD"\
                                     metadataFile="'"$(echo "${IDP_HOME}" | sed 's/\//\\\//g')"'\/metadata\/'"${SP_HOST}"'.xml" \/>/' "${IDP_HOME}"/conf/relying-party.xml

  wget --no-check-certificate "${SP_URL}" -O "${IDP_HOME}/metadata/${SP_HOST}.xml"

  echo "Waiting for Tomcat to be stopped..."
  until tail -1 "${IDP_TOMCAT_HOME}"/logs/catalina.out | grep -q -F 'org.apache.coyote.AbstractProtocol.destroy Destroying ProtocolHandler ["ajp-nio-7009"]'; do
    echo "[$(date "+%H:%M:%S")] Tomcat is not yet stopped - sleeping"
    sleep 2
  done

  rm -f "${IDP_HOME}"/logs/idp-process.log
  startAndWaitForIdP
fi

tail -f "${IDP_HOME}"/logs/idp-process.log
