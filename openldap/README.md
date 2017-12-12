# About / Synopsis

An OpenLDAP docker image provisioned with data and used for functional testing, dev and support at Nuxeo.<br><br>

It is based on [osixia/openldap:1.1.10](https://github.com/osixia/docker-openldap/tree/v1.1.10) image and features [OpenLDAP](https://www.openldap.org/) 2.4.44.

# Content Listing TODO

# Table of contents TODO

Use for instance https://github.com/ekalinin/github-markdown-toc

# Usage

## Quickstart
Just do:
```bash
    make
```

The target `all` will be used. This will clean any previous image data, build the new image and test it.

## Targets

The `Jenkinsfile` relies on a `Makefile` that can be manually used. Here are the main targets:

#### clean
Clean any previous image data on the local machine.

#### build

- generate the users LDIF file
- generate the static groups LDIF files
- build a docker image `nuxeo/openldap` based on the [image/Dockerfile](image/Dockerfile) file.

#### start
Start the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

#### stop
Stop the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

#### test
Run the tests on the image named **openldap_test**.

#### push
Push the image to the https://dockerpriv.nuxeo.com/ registry.<br>
It will fail if the Git tag already exists.

#### tag
Add a Git tag for the current image version.

# Code
## QA

[![Build Status](https://qa.nuxeo.org/jenkins/buildStatus/icon?job=/Deploy/IT-nuxeo-tools-docker-openldap)](https://qa.nuxeo.org/jenkins/job/Deploy/job/IT-nuxeo-tools-docker-openldap/)

## Content

See [image/README.md](image/README.md)

```bash
├── image                           # data needed to build the image
│   └── Dockerfile
├── Jenkinsfile
├── Makefile
├── scripts                         # LDAP populating
└── tests                           # Tests tooling
```

## Requirements TODO

shunit2, jq

# Resources (Documentation and other links) TODO

