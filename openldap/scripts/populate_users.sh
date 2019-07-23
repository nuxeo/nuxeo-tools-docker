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
. "${__ORIGIN_FOLDER}"/set_vars.sh

main() {
  local users_idx=0
  local ou_list

  true > "${USERS_FILE}"

  ou_list="$(grep -E "dn:.*${PEOPLE_UNIT}" "${STRUCTURE_FILE}" | cut -d ' ' -f 2 | sed "/^${PEOPLE_UNIT}$/d")"

  if [ -n "${ou_list}" ]; then
    while read -r unit; do
      injectUsers "${unit}" "${users_idx}" "$(( users_idx + USERS_PER_OU - 1 ))"
      (( users_idx+=USERS_PER_OU ))
    done <<< "${ou_list}"
  fi

  injectUsers "${PEOPLE_UNIT}" "${users_idx}"
}

# Add users to the LDIF file
#
# unit_name the Dn of the unit in which the users will be added
# idx_begin the id of the first user to add (i.e. 212 and not user212)
# idx_end   the id of the last user +1 (if 453 then the last added user will be user452)
#
injectUsers() {
  local unit_name=$1
  local idx_begin=$2
  local idx_end=${3:-$(( USERS_NUMBER - 1 ))}

  for i in $(seq -f "%0${#USERS_NUMBER}g" "${idx_begin}" "${idx_end}"); do
    cat >> "${USERS_FILE}" << EOF
dn: uid=user${i},${unit_name}
objectClass: inetOrgPerson
cn: user${i} full name
uid: user${i}
userPassword: user${i}
mail: devnull+user${i}@nuxeo.com
sn: user${i} lastname
givenName: user${i} firstname

EOF

  done
}

main "$@"
