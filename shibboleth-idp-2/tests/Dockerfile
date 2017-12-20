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

FROM openjdk:8u151-jdk-slim

LABEL maintainer="Nuxeo Packagers <packagers+docker-shibboleth-idp-2@nuxeo.com>" \
      description="A client built on-the-fly for executing tests"

ENV TEST_USER="thetester" \
    TEST_GROUP="thetester" \
    TEST_FOLDER="/testing"

RUN apt-get update && apt-get install wget -y; \
    set -ex; \
    groupadd -f ${TEST_GROUP}; \
    useradd -s /bin/false -g ${TEST_GROUP} -d "${TEST_FOLDER}" ${TEST_USER}; \
    mkdir "${TEST_FOLDER}"; \
    chown ${TEST_USER}:${TEST_GROUP} "${TEST_FOLDER}" -R

USER "${TEST_USER}"
WORKDIR "${TEST_FOLDER}"