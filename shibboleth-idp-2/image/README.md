# Image Content
A docker file based on [openjdk:8u151-jdk-slim](https://github.com/docker-library/openjdk/blob/a893fe3cd82757e7bccc0948c88bfee09bd916c3/8-jdk/slim/Dockerfile) for small footprint (299MB)<br><br>

It contains:

1. HTTPS enabled SAML2 IdP (see **IDP_TOMCAT_HTTPS_PORT** parameter for setting the port)
2. It exposes the following LDAP user attributes: uid, mail, cn, sn, givenName
3. Configuration variables are available (see [Dockerfile](Dockerfile)) and docker-compose files in the [test](../tests) folder.

### Dockerfile
A docker file that extends the Debian JDK slim one, retrieves archives, installs Tomcat and uncompresses the IdP.

### Entrypoint
The entrypoint will install and configure the IdP while starting the docker container.  

### Variables
* [WAIT_FOR_SP_AND_REG] It can optionnally wait for a Service Provider to retrieve the IdP metadata and then proceed automatically through SP registration (default value is **false**). 
* [SP_TYPE] Both Shibboleth SP and Nuxeo SP are supported through the **SP_TYPE** parameter (default value is **Shibboleth**).
* [ENCRYPT_SAML_ASSERTIONS] Enabling SAML assertions is done with **true** or disabled with **false** (default value is **true**).