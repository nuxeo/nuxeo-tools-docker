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

# organizational units LDIF file
readonly STRUCTURE_FILE="${__ORIGIN_FOLDER}"/../image/ldif/20-structure.ldif
# users LDIF file
readonly USERS_FILE="${__ORIGIN_FOLDER}"/../image/ldif/31-users-people.ldif
# groupOfNames groups LDIF file
readonly GROUPS_GON_FILE="${__ORIGIN_FOLDER}"/../image/ldif/40-groups-static-names.ldif
# groupOfUniqueNames groups LDIF file
readonly GROUPS_GOUN_FILE="${__ORIGIN_FOLDER}"/../image/ldif/41-groups-static-unique-names.ldif

# base DN for the whole LDAP tree (users, groups, ou, ...)
readonly BASE_DN="dc=nuxeo,dc=com"
# ou for the users
readonly PEOPLE_UNIT="ou=people,${BASE_DN}"
# ou for the groups
readonly GROUPS_UNIT="ou=groups,${BASE_DN}"
# ou for the groupOfNames groups (member attribute)
readonly GROUPS_GON_UNIT="ou=gon,ou=static,${GROUPS_UNIT}"
# ou for the groupOfUniqueNames groups (uniquemmember attribute)
readonly GROUPS_GOUN_UNIT="ou=gou,ou=static,${GROUPS_UNIT}"

# total number of users in the LDAP tree
readonly USERS_NUMBER=300
# number of users in an OU
readonly USERS_PER_OU=25
# number of groupOfNames groups
readonly GROUPS_GON_NUMBER=15 # groups of names
# number of groupOfUniqueNames groups
readonly GROUPS_GOUN_NUMBER=16 # groups of unique names
# number of users (member attribute) in a groupOfNames group
readonly USERS_PER_GROUP_GON=8
# number of users (uniquemember attribute) in a groupOfUniqueNames group
readonly USERS_PER_GROUP_GOUN=6
