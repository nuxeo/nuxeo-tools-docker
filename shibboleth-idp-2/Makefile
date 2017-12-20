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

SHELL=/bin/bash
TAG_NAME=nuxeo/shibboleth-idp-2
NAME=dockerpriv.nuxeo.com:443/$(TAG_NAME)
VERSION=1.0.0
BUILD_VERSION=$(VERSION)
TAG_VERSION=latest
SCM_REF=PIPELINE-SCM-VALUE
COMPOSE_FILE=tests/docker-compose.yml
IDP_DEFAULT_PORT=7443

.PHONY: all clean build start stop test push tag pushdev

all: clean build test

clean:
	-CONTAINER_SHIB_PORT=$(IDP_DEFAULT_PORT) docker-compose --file tests/docker-compose.yml rm -f
	@echo "Cleaning remaining docker datas..."
	-docker image prune -f
	-docker rm $(docker ps --filter=status=exited --filter=status=created -q) 2>/dev/null
	-docker image ls | grep -E "none|$(NAME)" | grep -E "none|latest|$(VERSION)-SNAPSHOT" | sed 's/  */ /g' | cut -d ' ' -f 3 | xargs docker image rm -f 2>/dev/null

build:
	@echo "BUILD_VERSION=$(BUILD_VERSION)"
	@echo "TAG_VERSION=$(TAG_VERSION)"
	sed -i "s/^\\s*version=.*/      version=\"$(BUILD_VERSION)\" \\\/g" image/Dockerfile
	sed -i "s/^\\s*SCM_REF=.*/      SCM_REF=\"$(SCM_REF)\" \\\/g" image/Dockerfile
	docker image build --tag "$(NAME):$(TAG_VERSION)" --no-cache --rm ./image
	@echo
	@echo "Labels inside the built image:"
	@docker inspect $(NAME):$(TAG_VERSION) | jq .[].Config.Labels
	@echo

start:
	@echo
	@echo "Starting containers..."
	CONTAINER_SHIB_PORT=$(IDP_DEFAULT_PORT)	docker-compose --file ./$(COMPOSE_FILE) up -d

stop:
	@echo
	@echo "Stopping containers..."
	CONTAINER_SHIB_PORT=$(IDP_DEFAULT_PORT)	docker-compose --file ./$(COMPOSE_FILE) down

test:
	@echo "Building client image..."
	docker image build --tag "idp-testing-client:latest" --no-cache --rm ./tests
	@echo "Testing with ./tests/docker-compose.yml"
	sed -i "$(shell grep -n image: tests/docker-compose.yml | tail -1 | cut -d ':' -f 1)s,^\\s*image:.*,    image: $(NAME):$(TAG_VERSION),g" tests/docker-compose.yml
	docker-compose --file ./tests/docker-compose.yml up -d
	CONTAINER_SHIB_PORT=7443 ./tests/container_tests.sh
	docker-compose --file ./tests/docker-compose.yml down
	@echo "Testing with ./tests/docker-compose-alternate-port.yml"
	sed -i "$(shell grep -n image: tests/docker-compose-alternate-port.yml | tail -1 | cut -d ':' -f 1)s,^\\s*image:.*,    image: $(NAME):$(TAG_VERSION),g" tests/docker-compose-alternate-port.yml
	docker-compose --file ./tests/docker-compose-alternate-port.yml up -d
	CONTAINER_SHIB_PORT=11298 ./tests/container_tests.sh
	docker-compose --file ./tests/docker-compose-alternate-port.yml down

push:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	@if git tag -l | grep -q $(TAG_NAME)-$(VERSION); then echo "Tag already exists. No need to push new image build."; exit 1; fi
	@echo "Pushing tag $(TAG_VERSION)..."
	docker push $(NAME):$(TAG_VERSION)

tag:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	git tag $(TAG_NAME)-$(VERSION)
	git push origin $(TAG_NAME)-$(VERSION)

pushdev: BUILD_VERSION=$(VERSION)-SNAPSHOT
pushdev: TAG_VERSION=$(BUILD_VERSION)
pushdev: clean build test push