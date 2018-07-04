#!/bin/bash
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

# autodetects origin folder of the test file
readonly __ORIGIN_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

readonly CONTAINER_SHIB_NAME="shibboleth_idp_test"
readonly IDP_HOST_NAME="idp.shibboleth.com"
readonly CONTAINER_CLIENT_NAME="shibboleth_idp_client_test"
CONTAINER_SHIB_PORT="${CONTAINER_SHIB_PORT:-"7443"}"

oneTimeSetUp() {
  echo "Starting tests..."
  echo
}

setUp() {
  echo
}

tearDown() {
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml down 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-shibboleth.yml down 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-nuxeo.yml down 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-unknown.yml down 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml rm 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-shibboleth.yml rm 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-nuxeo.yml rm 2>/dev/null
  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-unknown.yml rm 2>/dev/null 
}

waitForIdPStartup() {
  echo "Waiting for Shibboleth server startup..."
  until docker exec -i "${CONTAINER_SHIB_NAME}" [ -f /opt/shibboleth-idp/logs/idp-process.log ]; do
    echo "Shibboleth IdP is not starting up - sleeping"
    sleep 2
  done
}

testDefaultSPType() {
  local cmd_out

  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose.yml up -d

  waitForIdPStartup

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SP metadata URL is https://sp.shibboleth.com/Shibboleth.sso/Metadata'
  assertTrue "[docker logs] wrong SP metadata url" $?
}

testShibbolethSPType() {
  local cmd_out

  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-shibboleth.yml up -d

  waitForIdPStartup

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SP metadata URL is https://sp.shibboleth.com/Shibboleth.sso/Metadata'
  assertTrue "[docker logs] wrong SP metadata url" $?
}

testNuxeoSPType() {
  local cmd_out

  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-nuxeo.yml up -d

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'SP metadata URL is https://sp.shibboleth.com/nuxeo/saml/metadata'
  assertTrue "[docker logs] wrong SP metadata url" $?
}

testUnknownSPType() {
  local cmd_out

  docker-compose --file "${__ORIGIN_FOLDER}"/docker-compose-sp-testing-unknown.yml up -d

  docker logs ${CONTAINER_SHIB_NAME} | grep -qF 'ERROR: unknown SP type [SomeUnknownSAMLSP]'
  assertTrue "[docker logs] wrong SP type should raise an ERROR" $?
}

# shellcheck disable=1090
. "${SHUNIT2_HOME}/shunit2"
