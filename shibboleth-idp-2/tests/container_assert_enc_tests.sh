#!/bin/bash
##
## (C) Copyright 2017-2018 Nuxeo (http://nuxeo.com/) and others.
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

# autodetects origin folder of the test file
readonly __ORIGIN_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

readonly CONTAINER_SHIB_NAME="shibboleth_idp_test"
readonly IDP_HOST_NAME="idp.shibboleth.com"
CONTAINER_SHIB_PORT="${CONTAINER_SHIB_PORT:-"7443"}"

oneTimeSetUp() {
  echo "Starting tests..."
  echo
}

setUp() {
  echo
}

tearDown() {
  echo
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml kill 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-assert-enc.yml kill 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml rm --force 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-assert-enc.yml rm --force 2>/dev/null
}

waitForIdPStartup() {
  echo "Waiting for Shibboleth server startup..."
  until docker exec -i "${CONTAINER_SHIB_NAME}" [ -f /opt/shibboleth-idp/logs/idp-process.log ]; do
    echo "Shibboleth IdP is not starting up - sleeping"
    sleep 2
  done
}

testDefaultParamValue() {
  local cmd_out

  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml up -d

  waitForIdPStartup

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SAML assertions encryption is enabled.'
  assertTrue "[docker logs] cannot find assertions message" $?
  cmd_out=$(docker exec -i "${CONTAINER_SHIB_NAME}" sh -c 'grep -c "encryptAssertions=\"conditional\"" /opt/shibboleth-idp/conf/relying-party.xml')
  assertEquals "[docker exec] wrong assertions encryption configuration" 4 "${cmd_out}"
}

testEncryptionDisabled() {
  local cmd_out

  export ENCRYPT_SAML_ASSERTIONS=false
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-assert-enc.yml up -d

  waitForIdPStartup

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SAML assertions encryption is disabled.'
  assertTrue "[docker logs] cannot find assertions message" $?
  cmd_out=$(docker exec -i "${CONTAINER_SHIB_NAME}" sh -c 'grep -c "encryptAssertions=\"never\"" /opt/shibboleth-idp/conf/relying-party.xml')
  assertEquals "[docker exec] wrong assertions encryption configuration" 4 "${cmd_out}"
}

testEncryptionEnabled() {
  local cmd_out

  export ENCRYPT_SAML_ASSERTIONS=true
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-assert-enc.yml up -d

  waitForIdPStartup

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SAML assertions encryption is enabled.'
  assertTrue "[docker logs] cannot find assertions message" $?
  cmd_out=$(docker exec -i "${CONTAINER_SHIB_NAME}" sh -c 'grep -c "encryptAssertions=\"conditional\"" /opt/shibboleth-idp/conf/relying-party.xml')
  assertEquals "[docker exec] wrong assertions encryption configuration" 4 "${cmd_out}"
}

testUnknownParamValue() {
  local cmd_out

  export ENCRYPT_SAML_ASSERTIONS=blah
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-assert-enc.yml up -d

  sleep 3

  docker logs ${CONTAINER_SHIB_NAME} | grep -qF 'ERROR: unknown ENCRYPT_SAML_ASSERTIONS value [blah]'
  assertTrue "[docker logs] cannot find assertions message" $?
}

# shellcheck disable=1090
. "${SHUNIT2_HOME}/shunit2"
