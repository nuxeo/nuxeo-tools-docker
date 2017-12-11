# scripts
Here are the scripts used to populate the users and static groups LDIF files.<br>
They should be run in this order (see [**Makefile**](../Makefile)):<br>
```bash
    populate_users.sh
    populate_static_groups.sh
```
Those scripts can be either used to build a customized docker image or generate new LDIF files and import them in a running docker container.
### set_vars.sh
This script is called from within the populating scripts to initialize variables.<br>
This allows to easily modify the number of users needed as well as the static groups (groupOfNames and groupOfUniqueNames).<br>
It is also possible to set the number of users per OU or the number of users per static group. See the [**set_vars.sh**](set_vars.sh) script for further details.
### populate_users.sh
Generates an LDIF file (defined by the **USERS_FILE** variable) containing all the users.
### populate_static_groups.sh
Generates LDIF files (defined by the **GROUPS_GON_FILE** and **GROUPS_GOUN_FILE** variables) containing all the static groups.<br>
It uses the **USERS_FILE** to add members.