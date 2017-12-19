# About / Synopsis

* What is it, what does it do / Abstract
* Project status: working/prototype

* Nuxeo Support: internal usage, no support.

# Table of contents

# Content Listing

# Resources (Documentation and other links)

# Contributing / Reporting issues

Link to JIRA component (or project if there is no component for that project).
Sample: https://jira.nuxeo.com/browse/NXP/component/14503/
Sample: https://jira.nuxeo.com/secure/CreateIssue!default.jspa?project=NXP

# License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

Sample: https://github.com/nuxeo/nuxeo-drive

# About Nuxeo

The [Nuxeo Platform](http://www.nuxeo.com/products/content-management-platform/) is an open source customizable and extensible content management platform for building business applications. It provides the foundation for developing [document management](http://www.nuxeo.com/solutions/document-management/), [digital asset management](http://www.nuxeo.com/solutions/digital-asset-management/), [case management application](http://www.nuxeo.com/solutions/case-management/) and [knowledge management](http://www.nuxeo.com/solutions/advanced-knowledge-base/). You can easily add features using ready-to-use addons or by extending the platform using its extension point system.

The Nuxeo Platform is developed and supported by Nuxeo, with contributions from the community.

Nuxeo dramatically improves how content-based applications are built, managed and deployed, making customers more agile, innovative and successful. Nuxeo provides a next generation, enterprise ready platform for building traditional and cutting-edge content oriented applications. Combining a powerful application development environment with
SaaS-based tools and a modular architecture, the Nuxeo Platform and Products provide clear business value to some of the most recognizable brands including Verizon, Electronic Arts, Sharp, FICO, the U.S. Navy, and Boeing. Nuxeo is headquartered in New York and Paris.
More information is available at [www.nuxeo.com](http://www.nuxeo.com).

-----------


# nuxeo-tools-docker
Various Docker files used at Nuxeo

## Versioning convention
Once the docker image is ready, a tag should be created with the format:

```bash
<IMAGE_NAME>-<VERSION>
```

For example:
```bash
openldap-1.0.0
```

The versioning data are then included into the image before publishing using the following [labels](https://docs.docker.com/engine/reference/builder/#label):
- version
- scm-ref
- scm-url
- description

This will allow to have the image version the author meant, the commit id, the url of the repository and the description.

For example, adding the data (in the Dockerfile) to a built image before publishing it:
```bash
    LABEL version="<VERSION>"
    LABEL scm-ref="<SCM_REF_VALUE>"
    LABEL scm-url="<SCM_REPOSITORY>"
    LABEL description="<This is a description that can span multiple lines.>"
```

will end up being replaced by the right values inside a build job:
```bash
    LABEL version="1.0.0"
    LABEL scm-ref="45b1fccbc75901f5655876aebecc980a5c2077af"
    LABEL scm-url="https://github.com/nuxeo/nuxeo-tools-docker"
    LABEL description="This is a description that can span multiple lines."
```

## Images
### ccextractor
### ffmpeg
### jenkins-slave
### libsass
### nuxeo-cluster
### nuxeo
### nuxeobase
### openldap



An OpenLDAP image used for functional testing, dev and support at Nuxeo.

### shibboleth-sp


A Shibboleth service provider image for functional testing, dev and support at Nuxeo.

### oracle11g
### webdriver
