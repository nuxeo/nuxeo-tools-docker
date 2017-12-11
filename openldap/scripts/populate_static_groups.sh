#!/bin/bash
##
## (C) Copyright 2006-2017 Nuxeo (http://nuxeo.com/) and others.
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

# this script must be run AFTER populate_users.sh and reads values from it

# autodetects origin folder of the test file
readonly __ORIGIN_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=1090
. "${__ORIGIN_FOLDER}"/set_vars.sh

readonly LDIF_USERS_NUMBER="$(grep -c "dn:" "${USERS_FILE}")"

main() {
  local users_idx=0

  true > "${GROUPS_GON_FILE}"
  true > "${GROUPS_GOUN_FILE}"

  # groups of names
  for gon_idx in $(seq -f "%0${#GROUPS_GON_NUMBER}g" "0" "$(( GROUPS_GON_NUMBER - 1 ))"); do
    createGonGroup "${gon_idx}" "${users_idx}" "$(( users_idx + USERS_PER_GROUP_GON - 1 ))"
    (( users_idx+=USERS_PER_GROUP_GON ))
  done

  # groups of unique names
  for goun_idx in $(seq -f "%0${#GROUPS_GOUN_NUMBER}g" "0" "$(( GROUPS_GOUN_NUMBER - 1 ))"); do
    createGounGroup "${goun_idx}" "${users_idx}" "$(( users_idx + USERS_PER_GROUP_GOUN - 1 ))"
    (( users_idx+=USERS_PER_GROUP_GOUN ))
  done
}

# Add a groupOfNames group to the LDIF file with its members to the GROUPS_GON_UNIT ou
#
# group_idx the id of the group to be added in which the users will be added
# idx_begin the id of the first user to add (i.e. 212 and not user212)
# idx_end   the id of the last user
#
createGonGroup() {
  local group_idx=$1
  local idx_begin=$2
  local idx_end=$3
  local cn
  cn="gon${group_idx}"

  cat >> "${GROUPS_GON_FILE}" << EOF
dn: cn=${cn},${GROUPS_GON_UNIT}
objectclass: groupOfNames
cn: ${cn}
description: Group of names ${cn}
EOF

  for i in $(seq -f "%0${#LDIF_USERS_NUMBER}g" "${idx_begin}" "${idx_end}"); do
    echo "member: $(grep "user${i}" "${USERS_FILE}" | grep dn: | cut -d ' ' -f 2)" >> "${GROUPS_GON_FILE}"
  done

  echo >> "${GROUPS_GON_FILE}"
}

# Add a groupOfUniqueNames group to the LDIF file with its unique members to the GROUPS_GOUN_UNIT ou
#
# group_idx the id of the group to be added in which the users will be added
# idx_begin the id of the first user to add (i.e. 212 and not user212)
# idx_end   the id of the last user
#
createGounGroup() {
  local group_idx=$1
  local idx_begin=$2
  local idx_end=$3
  local cn
  cn="goun${group_idx}"

  cat >> "${GROUPS_GOUN_FILE}" << EOF
dn: cn=${cn},${GROUPS_GOUN_UNIT}
objectclass: groupOfUniqueNames
cn: ${cn}
description: Group of unique names ${cn}
EOF

  for i in $(seq -f "%0${#LDIF_USERS_NUMBER}g" "${idx_begin}" "${idx_end}"); do
    echo "uniquemember: $(grep "user${i}" "${USERS_FILE}" | grep dn: | cut -d ' ' -f 2)" >> "${GROUPS_GOUN_FILE}"
  done

  echo >> "${GROUPS_GOUN_FILE}"
}

main "$@"
