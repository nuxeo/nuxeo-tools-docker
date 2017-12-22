# Table of contents

   * [About / Synopsis](#about--synopsis)
   * [Content Listing](#content-listing)
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

# About / Synopsis

A Shibboleth IdP docker image using LDAP as user repository for functional testing, dev and support at Nuxeo.<br><br>

It is based on [openjdk:8u151-jdk-slim](https://github.com/docker-library/openjdk/blob/a893fe3cd82757e7bccc0948c88bfee09bd916c3/8-jdk/slim/Dockerfile) image and features [Shibboleth](https://www.shibboleth.net) 2.4.5 and [Tomcat](https://tomcat.apache.org/download-80.cgi) 8.0.48.

# Content Listing

See [image/README.md](image/README.md)

```bash
├── image                           # data needed to build the image
│   └── Dockerfile
├── Jenkinsfile
├── Makefile
└── tests                           # Tests tooling
```

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

- build a docker image `nuxeo/shibboleth-idp-2` based on the [image/Dockerfile](image/Dockerfile) file.

#### start
Start the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

#### stop
Stop the container using the [tests/docker-compose.yml](tests/docker-compose.yml) file.

#### test
Run the tests on the image named **shibboleth_idp_test**.  
The SP registration feature has to be tested manually.

#### push
Push the image to the https://dockerpriv.nuxeo.com/ registry.<br>
It will fail if the Git tag already exists.

#### pushdev
Push a development image (tagged with <VERSION>-SNAPSHOT) to the https://dockerpriv.nuxeo.com/ registry.<br>

#### tag
Add a Git tag for the current image version.

# Code
## QA

[![Build Status](https://qa.nuxeo.org/jenkins/buildStatus/icon?job=/Deploy/IT-nuxeo-tools-docker-shibboleth-idp-2)](https://qa.nuxeo.org/jenkins/job/Deploy/job/IT-nuxeo-tools-docker-shibboleth-idp-2/)

## Requirements

GNU sed  
GNU make  
docker >= 17  
docker-compose >= 17  
shunit2  
jq  
LDAP server (i.e. [OpenLDAP](https://github.com/nuxeo/nuxeo-tools-docker/tree/master/openldap))

# Resources (Documentation and other links)

https://www.shibboleth.net/  
https://wiki.shibboleth.net/confluence/display/SHIB2/IdPInstall  
https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language  
https://en.wikipedia.org/wiki/SAML_2.0  
http://saml.xml.org/  
http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html