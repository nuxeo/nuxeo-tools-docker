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

# shellcheck disable=1090
. "${__ORIGIN_FOLDER}"/../scripts/set_vars.sh

readonly CONTAINER_NAME="openldap_test"
readonly CONTAINER_ADMIN="cn=admin,${BASE_DN}"
readonly CONTAINER_CONFIG_ADMIN="cn=admin,cn=config"
readonly CONTAINER_ADMINPWD="admin"
readonly CONTAINER_CONFIGPWD="admin"
readonly CONTAINER_READONLY_USER="cn=readonly,${BASE_DN}"
readonly CONTAINER_READONLY_PWD="readonly"
readonly CONTAINER_ACCESSLOG_BASEDN="cn=accesslog"

readonly LDIF_STRUCTURES_NUMBER="$(grep -c "dn:" "${STRUCTURE_FILE}")"

# shellcheck disable=1090
. "${__ORIGIN_FOLDER}"/ldap_tools.sh

oneTimeSetUp() {
  echo
  echo "Starting OpenLDAP container..."
  make --directory="${__ORIGIN_FOLDER}"/.. start >/dev/null

  echo "Waiting for LDAP server to be up..."
  until docker logs "${CONTAINER_NAME}" | grep -q "slapd starting"; do
    echo "OpenLDAP is unavailable - sleeping"
    sleep 2
  done

  echo "Starting tests..."
  echo
}

oneTimeTearDown() {
  echo
  echo "Stopping OpenLDAP container..."
  make --directory="${__ORIGIN_FOLDER}"/.. stop >/dev/null
}

testServerAnonymousIsAvailable() {
  local cmd_out

  cmd_out=$(ldapWhoAmI "")
  assertTrue "server does not answer" $?
  assertEquals "anonymous access does not work" "anonymous" "${cmd_out}"
}

testServerSimpleBind() {
  local cmd_out

  cmd_out=$(ldapWhoAmI "${CONTAINER_ADMIN}" "${CONTAINER_ADMINPWD}")
  assertTrue "server does not answer" $?
  assertEquals "simple bind failed" "dn:${CONTAINER_ADMIN}" "${cmd_out}"
}

testServerConfigSimpleBind() {
  local cmd_out

  cmd_out=$(ldapWhoAmI "${CONTAINER_CONFIG_ADMIN}" "${CONTAINER_CONFIGPWD}")
  assertTrue "server does not answer" $?
  assertEquals "simple config bind failed" "dn:${CONTAINER_CONFIG_ADMIN}" "${cmd_out}"
}

testServerReadonlyBind() {
  local cmd_out

  cmd_out=$(ldapWhoAmI "${CONTAINER_READONLY_USER}" "${CONTAINER_READONLY_PWD}")
  assertTrue "server does not answer" $?
  assertEquals "readonly bind failed" "dn:${CONTAINER_READONLY_USER}" "${cmd_out}"
}

testAdministratorUserExists() {
  local cmd_out

  cmd_out=$(ldapSearch "uid=Administrator" "dn" | grep -c "dn:")
  assertTrue "server does not answer" $?
  assertEquals "unable to find user Administrator" "1" "${cmd_out}"
}

testAccessLogOverlayRootDnAvailable() {
  local cmd_out

  cmd_out=$(ldapSearch "" "dn" "${CONTAINER_ACCESSLOG_BASEDN}" | grep -c dn:)
  assertTrue "server does not answer" $?
  assertTrue "unable to find accesslog root dn" "[ ${cmd_out} -gt 1 ]"
}

testAccessLogOverlayReadAuditEnable() {
  local audit_entries_before
  local audit_entries_after

  audit_entries_before=$(ldapSearch "" "dn" "${CONTAINER_ACCESSLOG_BASEDN}" | grep -c dn:)
  assertTrue "server does not answer" $?

  setAccessLogOps "all"

  ldapWhoAmI "" > /dev/null

  audit_entries_after=$(ldapSearch "" "dn" "${CONTAINER_ACCESSLOG_BASEDN}" | grep -c dn:)
  assertTrue "server does not answer" $?

  setAccessLogOps "writes"

  assertNotEquals "Audit entries number has not increased after read operations." "${audit_entries_before}" "${audit_entries_after}"
}

testStructureCreated() {
  local cmd_out

  cmd_out=$(ldapSearch "ou=*" "dn" | grep -c "dn:")
  assertTrue "server does not answer" $?
  assertEquals "incorrect number of units" "${LDIF_STRUCTURES_NUMBER}" "${cmd_out}"
}

testStructureCoherence() {
  local cmd_out

  cmd_out=$(ldapSearch "objectClass=organizationalUnit" "ou" | grep "ou:" | sort -u | grep -c "ou:")
  assertTrue "server does not answer" $?
  assertEquals "incorrect number of units" "${LDIF_STRUCTURES_NUMBER}" "${cmd_out}"
}

testUsersCreated() {
  local cmd_out

  cmd_out=$(ldapSearch "objectClass=inetOrgPerson" "dn" | grep -c "dn:")
  assertTrue "server does not answer" $?
  assertEquals "incorrect number of users" "$(( USERS_NUMBER + 1 ))" "${cmd_out}"
}

testStaticGroupsGonNumbersByCn() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=gon*" | grep -c cn:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups by cn" "${GROUPS_GON_NUMBER}" "${cmd_out}"
}

testStaticGroupsGonNumbersByObjectClass() {
  local cmd_out

  cmd_out=$(ldapSearch "objectClass=groupOfNames" | grep -c cn:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups by objectClass" "${GROUPS_GON_NUMBER}" "${cmd_out}"
}

testStaticGroupsGounNumbersByCn() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=goun*" | grep -c cn:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups" "${GROUPS_GOUN_NUMBER}" "${cmd_out}"
}

testStaticGroupsGounNumbersByObjectClass() {
  local cmd_out

  cmd_out=$(ldapSearch "objectClass=groupOfUniqueNames" | grep -c cn:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups" "${GROUPS_GOUN_NUMBER}" "${cmd_out}"
}

testStaticGroupsGonMembers() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=gon$(printf %0${#GROUPS_GON_NUMBER}d "0")" | grep -c member:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups" "${USERS_PER_GROUP_GON}" "${cmd_out}"
}

testStaticGroupsGounMembers() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=goun$(printf %0${#GROUPS_GOUN_NUMBER}d "0")" | grep -c uniqueMember:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find groups" "${USERS_PER_GROUP_GOUN}" "${cmd_out}"
}

testDynamicGroupsOverlayAllUsers() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=persons" | grep -c uid:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find users" "$(( USERS_NUMBER + 1 ))" "${cmd_out}"
}

testDynamicGroupsOverlaySalesPeople() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=salespeople" | grep -c uid:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find users" "$(( USERS_PER_OU * 3 ))" "${cmd_out}"
}

testDynamicGroupsOverlayDevGuys() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=devguys" | grep -c uid:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find users" "$(( USERS_PER_OU ))" "${cmd_out}"
}

testDynamicGroupsOverlayUsers00() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=users00" | grep -c uid:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find users" "$(grep -c -E "dn: uid=user00.*," "${USERS_FILE}")" "${cmd_out}"
}

# testDynamicGroupsOverlayAll7Users() {
#   local cmd_out

#   cmd_out=$(ldapSearch "cn=user7" | grep -c uid:)
#   assertTrue "server does not answer" $?
#   assertEquals "unable to find users" "$(grep -c -E "dn: uid=user.*7.*," "${USERS_FILE}")" "${cmd_out}"
# }

testDynamicGroupsOverlayNuxeoAdmins() {
  local cmd_out

  cmd_out=$(ldapSearch "cn=nuxeoadmins" | grep -c uid:)
  assertTrue "server does not answer" $?
  assertEquals "unable to find users" "1" "${cmd_out}"
}

testAccessLogDbConfigFileIsPresent() {
  assertFalse "DB_CONFIG is missing for accesslog database" "docker logs ${CONTAINER_NAME} | grep -q 'no DB_CONFIG file found in directory /var/lib/ldapaccesslog'"
}

testUniqueMemberIsEqualityIndexed() {
  local cmd_out

  ldapSearch "(&(uniqueMember=uid=user126,ou=core,ou=dev,ou=people,dc=nuxeo,dc=com)(&(&(|(objectClass=groupOfUniqueNames)(objectClass=groupOfURLs)))(cn=*)))" > /dev/null
  assertTrue "server does not answer" $?

  cmd_out=$(docker logs "${CONTAINER_NAME}" | grep -q 'bdb_equality_candidates: (uniqueMember) not indexed')
  assertFalse "uniqueMember is not indexed for equality" $?
}

testMemberIsEqualityIndexed() {
  local cmd_out

  ldapSearch "(&(member=uid=user000,ou=sales,ou=people,dc=nuxeo,dc=com)(&(&(|(objectClass=groupOfNames)(objectClass=groupOfURLs)))(cn=*)))" > /dev/null
  assertTrue "server does not answer" $?

  cmd_out=$(docker logs "${CONTAINER_NAME}" | grep -q 'bdb_equality_candidates: (member) not indexed')
  assertFalse "member is not indexed for equality" $?
}

# shellcheck disable=1090
. "${SHUNIT2_HOME}/shunit2"
