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
CONTAINER_SHIB_PORT="${CONTAINER_SHIB_PORT:-"7443"}"

oneTimeSetUp() {
  echo "CONTAINER_SHIB_PORT=${CONTAINER_SHIB_PORT}"
  echo "Waiting for Shibboleth server startup..."
  until docker exec -i "${CONTAINER_SHIB_NAME}" [ -f /opt/shibboleth-idp/logs/idp-process.log ]; do
    echo "Shibboleth IdP is not starting up - sleeping"
    sleep 2
  done

  echo "Starting tests..."
  echo
}

testProfileStatus() {
  local cmd_out

  cmd_out=$(docker exec -i "${CONTAINER_SHIB_NAME}" wget --no-check-certificate -qO- https://127.0.0.1:${CONTAINER_SHIB_PORT}/idp/profile/Status)
  assertEquals "incorrect IdP status" "ok" "${cmd_out}"
}

testLoginPageReachable() {
  docker exec -i "${CONTAINER_SHIB_NAME}" wget --no-check-certificate -qO- https://127.0.0.1:${CONTAINER_SHIB_PORT}/idp/Authn/UserPassword | grep -q 'Log in to Unspecified Service Provider'
  assertTrue "incorrect result when trying to reach the login page" $?
}

testLoginAdministratorUser() {
  loginUser "Administrator" "Administrator" | grep -q 'An error occurred while processing your request.'
  assertTrue "could not login Administrator user" $?

  sleep 3 # give time for docker to persist the logs

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'Successfully authenticated user Administrator'
  assertTrue "[docker logs] could not login Administrator user" $?
}

testLoginUser135() {
  loginUser "user135" "user135" | grep -q 'An error occurred while processing your request.'
  assertTrue "could not login user135 user" $?

  sleep 3 # give time for docker to persist the logs

  docker logs ${CONTAINER_SHIB_NAME} | grep -q 'Successfully authenticated user user135'
  assertTrue "[docker logs] could not login user135 user" $?
}

testFailedLoginUser046() {
  loginUser "user046" "password" | grep -q 'Login has failed. Double-check your username and password.'
  assertTrue "could not verify access denied for user046 user" $?
}

testIdPMetataPort() {
  local cmd_out

  cmd_out=$(docker exec -i "${CONTAINER_SHIB_NAME}" wget --no-check-certificate -qO- https://127.0.0.1:${CONTAINER_SHIB_PORT}/idp/shibboleth | grep -o ":${CONTAINER_SHIB_PORT}" | grep -c ":${CONTAINER_SHIB_PORT}")
  assertEquals "incorrect IdP status" "12" "${cmd_out}"
}

# utility method to perform a Shibboleth login
#
# user the user to login
# pass the user password
#
loginUser() {
  local user=$1
  local pass=$2

  docker exec -i "${CONTAINER_SHIB_NAME}" wget --no-check-certificate -qO- "https://127.0.0.1:${CONTAINER_SHIB_PORT}/idp/Authn/UserPassword?j_username=${user}&j_password=${pass}&_eventId=submit&submit=LOGIN"
}

# shellcheck disable=1090
. "${SHUNIT2_HOME}/shunit2"
