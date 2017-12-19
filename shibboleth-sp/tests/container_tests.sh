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
##     Funsho David

# autodetects origin folder of the test file
readonly __ORIGIN_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly CONTAINER_SP_NAME="shibboleth_sp_test"
readonly CONTAINER_IDP_NAME="shibboleth_idp_test"

oneTimeSetUp() {
  echo
  echo "Waiting for Shibboleth IDP startup..."
  until docker exec -i "${CONTAINER_IDP_NAME}" [ -f /opt/shibboleth-idp/logs/idp-process.log ]; do
    echo "Shibboleth IdP is not starting up - sleeping"
    sleep 2
  done
  echo "Waiting for Shibboleth daemon startup..."
  until docker exec -it "${CONTAINER_SP_NAME}" [ -f /var/log/shibboleth/shibd.log ]; do
    echo "Shibboleth SP is not starting up - sleeping"
    sleep 2
  done

  echo "Starting tests..."

}

testSPStatus() {
  docker exec -it ${CONTAINER_SP_NAME} curl -ksSL https://localhost/Shibboleth.sso/Status | grep -q "<Status><OK/></Status>"
  assertTrue "incorrect result when trying to reach the service provider" $?
}


# shellcheck disable=1090
. "${SHUNIT2_HOME}/shunit2"
