# About / Synopsis

A Shibboleth service provider docker image for functional testing, dev and support at Nuxeo.<br><br>

It is based on [centos:7](https://github.com/CentOS/sig-cloud-instance-images/blob/37e0a7f3d98ae875dac7ae1026e99c1c04524c62/docker/Dockerfile) image and features [Shibboleth](https://wiki.shibboleth.net/confluence/display/SHIB2/Home) 2.6.1.

# Content listing

See [image/README.md](image/README.md)

```bash
├── image                           # data needed to build the image
│   └── Dockerfile
├── Jenkinsfile
├── Makefile
└── tests                           # Tests tooling
```

# Table of contents

* [About / Synopsis](#about--synopsis)
* [Content listing](#content-listing)
* [Table of contents](#table-of-contents)
* [Usage](#usage)
  * [Quickstart](#quickstart)
  * [Targets](#targets)
     * [clean](#clean)
     * [build](#build)
     * [start](#start)
     * [stop](#stop)
     * [test](#test)
     * [push](#push)
     * [pushdev](#pushdev)
     * [tag](#tag)
* [Code](#code)
  * [QA](#qa)
  * [Requirements](#requirements)
* [Resources (Documentation and other links)](#resources-documentation-and-other-links)




# Usage

## Quickstart
Just do:
```bash
    make
```

The target `all` will be used. This will clean any previous image data, build the new image and test it.

## Targets

The `Jenkinsfile` relies on a `Makefile` that can be manually used. Here are the main targets:

### clean
Clean any previous image data on the local machine.

### build
Build a docker image `nuxeo/shibboleth-sp` based on the [image/Dockerfile](image/Dockerfile) file.

### start
Start the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

### stop
Stop the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

### test
Run the tests on the image named **shibboleth_sp_test**.

### push
Push the image to the https://dockerpriv.nuxeo.com/ registry.<br>
It will fail if the Git tag already exists.

### pushdev
Push a development image (tagged with <VERSION>-SNAPSHOT) to the https://dockerpriv.nuxeo.com/ registry.<br>

### tag
Add a Git tag for the current image version.

# Code
## QA

[![Build Status](https://qa.nuxeo.org/jenkins/buildStatus/icon?job=/Deploy/IT-nuxeo-tools-docker-shibboleth-sp)](https://qa.nuxeo.org/jenkins/job/Deploy/job/IT-nuxeo-tools-docker-shibboleth-sp/)

## Requirements

GNU sed  
GNU make  
docker >= 17  
docker-compose >= 17  
shunit2  
jq

# Resources (Documentation and other links)

https://www.shibboleth.net/  
https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPInstall