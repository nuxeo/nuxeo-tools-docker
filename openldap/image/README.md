# Image Content
A docker file based on [osixia/docker-openldap](https://github.com/osixia/docker-openldap)<br><br>

It contains:

1. Existing [overlays](https://www.openldap.org/doc/admin24/overlays.html) from the osixia/docker-openldap image:
  - memberof
  - refint
2. Added [overlays](https://www.openldap.org/doc/admin24/overlays.html):
  - accesslog
  - dynlist
3. 300 users
4. 25 organizational units
5. 15 groupOfNames groups
6. 16 groupOfUniqueNames groups
7. 6 dynamic groups

### Dockerfile
A docker file that extends an existing one, configures overlays and populates the LDAP tree

### Environment
Parameters override from the **osixia/docker-openldap** image. (see [here](https://github.com/osixia/docker-openldap#environment-variables))

### ldif
OUs, users, groups, server configuration.<br>
For faster import, accesslog has 99 number in the ldif files thus it is enabled at last. (99-config-accesslog.ldif)