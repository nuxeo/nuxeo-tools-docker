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
TAG-NAME=nuxeo/openldap
NAME=dockerpriv.nuxeo.com:443/$(TAG-NAME)
VERSION=1.0.1
SCM-REF=PIPELINE-SCM-VALUE

all: clean build test

clean:
	-docker-compose --file tests/docker-compose.yml rm -f
	@echo "Cleaning remaining docker datas..."
	-docker rm $(docker ps --filter=status=exited --filter=status=created -q) 2>/dev/null
	-docker image ls | grep "$(NAME)" | grep "latest" | sed 's/  */ /g' | cut -d ' ' -f 3 | xargs docker image rm -f 2>/dev/null

build:
	scripts/populate_users.sh
	scripts/populate_static_groups.sh
	sed -i "s/^LABEL\\s*version=.*/LABEL version=\"$(VERSION)\"/g" image/Dockerfile
	sed -i "s/^LABEL\\s*scm-ref=.*/LABEL scm-ref=\"$(SCM-REF)\"/g" image/Dockerfile
	docker image build --tag "$(NAME):latest" --no-cache --rm ./image
	@echo
	@echo "Labels inside the built image:"
	@docker inspect $(NAME):latest | jq .[].Config.Labels
	@echo

start:
	docker-compose --file ./tests/docker-compose.yml up -d

stop:
	docker-compose --file ./tests/docker-compose.yml down

test:
	sed -i "s,^\\s*image:.*,    image: $(NAME),g" tests/docker-compose.yml
	./tests/container_tests.sh

push:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	@if git tag -l | grep -q $(TAG-NAME)-$(VERSION); then echo "Tag already exists. No need to push new image build."; exit 1; fi
	docker push $(NAME):latest

tag:
	@echo "Refreshing local tags..."
	git tag -l | xargs git tag -d
	git fetch --tags
	git tag $(TAG-NAME)-$(VERSION)
	git push origin $(TAG-NAME)-$(VERSION)
	