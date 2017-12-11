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

# Performs whoami query
#
# user the user dn
# pass the user password
#
ldapWhoAmI() {
    local user=$1
    local pass=$2
    local credentials=${user:+ -D "${user}" -w "${pass}"} # empty if no credentials needed

    # shellcheck disable=2086
    docker exec -i "${CONTAINER_NAME}" ldapwhoami -x -H ldap://localhost ${credentials} 2>/dev/null
}

# Performs ldapsearch query (as admin user)
#
# filter the LDAP filter
# attrs  the list of attributes to return (space separated)
# basedn base dn (optional)
#
ldapSearch() {
    local filter=$1
    local attrs=$2
    local basedn=${3:-${BASE_DN}}

    # shellcheck disable=2086
    docker exec -i "${CONTAINER_NAME}" ldapsearch -x -H ldap://localhost -D "${CONTAINER_ADMIN}" -w "${CONTAINER_ADMINPWD}" -b "${basedn}" ${filter} ${attrs} 2>/dev/null
}

# Modify access log audited operations (as admin user)
#
# ops the operations audited (writes, reads, all, ...)
#
setAccessLogOps() {
    local ops=$1

    docker exec -i "${CONTAINER_NAME}" ldapmodify -x -H ldap://localhost -D "${CONTAINER_CONFIG_ADMIN}" -w "${CONTAINER_CONFIGPWD}" >/dev/null 2>/dev/null << EOF
dn: olcOverlay={3}accesslog,olcDatabase={1}hdb,cn=config
changetype: modify
replace: olcAccessLogOps
olcAccessLogOps: ${ops}

EOF
}
