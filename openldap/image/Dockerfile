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

FROM osixia/openldap:1.1.10

LABEL maintainer="Nuxeo Packagers <packagers+docker-openldap@nuxeo.com>"
LABEL version="1.0.2"
LABEL scm-ref="PIPELINE-SCM-VALUE"
LABEL scm-url="https://github.com/nuxeo/nuxeo-tools-docker"
LABEL description="An OpenLDAP image provisioned with datas, ready for dev, testing, support"

# Those variables will be set here to avoid any misconfiguration in docker compose
ADD environment /container/environment/01-custom

# Creating access log file
RUN mkdir -p /var/lib/ldapaccesslog
RUN chown openldap:openldap /var/lib/ldapaccesslog
ADD database/DB_CONFIG /var/lib/ldapaccesslog

# Populating LDAP server
RUN cp /etc/ldap/schema/dyngroup.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/01-dyngroup-schema.ldif
ADD ldif/02-config-dynlist.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/03-config-indexes-add-cn.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/20-structure.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/30-users-administrator.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/31-users-people.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/40-groups-static-names.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/41-groups-static-unique-names.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/42-groups-dynamic.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
ADD ldif/99-config-accesslog.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom

EXPOSE 389
EXPOSE 636
