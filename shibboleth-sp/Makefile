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

SHELL=/bin/bash
TAG_NAME=nuxeo/shibboleth-sp
NAME=dockerpriv.nuxeo.com:443/$(TAG_NAME)
VERSION=1.0.0
BUILD_VERSION=$(VERSION)
TAG_VERSION=latest
SCM-REF=PIPELINE-SCM-VALUE

all: clean build test

clean:
	-docker-compose --file tests/docker-compose.yml rm -f
	@echo "Cleaning remaining docker datas..."
	-docker rm $(docker ps --filter=status=exited --filter=status=created -q) 2>/dev/null
	-docker image ls | grep -E "none|$(NAME)" | grep -E "none|latest|$(VERSION)-SNAPSHOT" | sed 's/  */ /g' | cut -d ' ' -f 3 | xargs docker image rm -f 2>/dev/null

build:
	sed -i "s/^LABEL\\s*version=.*/LABEL version=\"$(BUILD_VERSION)\"/g" image/Dockerfile
	sed -i "s/^LABEL\\s*scm-ref=.*/LABEL scm-ref=\"$(SCM-REF)\"/g" image/Dockerfile
	docker image build --tag "$(NAME):$(TAG_VERSION)" --no-cache --rm ./image
	@echo
	@echo "Labels inside the built image:"
	@docker inspect $(NAME):$(TAG_VERSION) | jq .[].Config.Labels
	@echo

start:
	docker-compose --file ./tests/docker-compose.yml up -d

stop:
	docker-compose --file ./tests/docker-compose.yml down

test:
	# replacing the last image line in the docker-compose.yml file
	sed -i "$(shell grep -n image: tests/docker-compose.yml | tail -1 | cut -d ':' -f 1)s,^\\s*image:.*,    image: $(NAME),g" tests/docker-compose.yml
	docker-compose --file ./tests/docker-compose.yml up -d
	./tests/container_tests.sh
	docker-compose --file ./tests/docker-compose.yml down

push:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	@if git tag -l | grep -q $(TAG-NAME)-$(VERSION); then echo "Tag already exists. No need to push new image build."; exit 1; fi
	@echo "Pushing tag $(TAG_VERSION)..."
	docker push $(NAME):$(TAG_VERSION)

tag:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	git tag $(TAG-NAME)-$(VERSION)
	git push origin $(TAG-NAME)-$(VERSION)

pushdev: BUILD_VERSION=$(VERSION)-SNAPSHOT
pushdev: TAG_VERSION=$(BUILD_VERSION)
pushdev: clean build test push
