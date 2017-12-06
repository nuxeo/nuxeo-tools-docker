# nuxeo-tools-docker
Various Docker files used at Nuxeo

## Versioning convention
1. Once the docker image is ready, a tag should be created with the format:
```bash
<IMAGE_NAME>-<VERSION>
```
For example:
```bash
openldap-1.0.0
```

2. the versioning data are then included into the image before publishing using the following [labels](https://docs.docker.com/engine/reference/builder/#label):
- version
- scm-ref
- scm-url
- description

This will allow to have the image version the author meant, the commit id, the url of the repository and the description.

3. For example, adding the datas (in the Dockerfile) to a built image before publishing it:
```bash
    LABEL version="1.0.0"
    LABEL scm-ref="SCM-REF-VALUE"
    LABEL scm-url="https://github.com/nuxeo/nuxeo-tools-docker"
    LABEL description="This is a description that can span multiple lines." 
```
4. Which should end up being replaced by the right values inside a build job:
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
### oracle11g
### webdriver
