Deploy Nuxeo and PostgreSQL with ansible.


Disclaimer: do not run those on an existing instance without understanding what they do! You will probably lose your data if you do!


You must have a recent version of ansible for those scripts: 1.7+, or 1.8-dev+ for the docker deployments
(it is recommended to use ansible in a virtualenv as some dependencies may mess up your system packages otherwise)

More details Soon(tm).


- Both on the same host:

Edit the host name/IP in hosts-cloud
Host must be configured so you can connect to the ubuntu user with your ssh key.
Ubuntu user must have passwordless sudo.

ansible-playbook -i hosts-cloud deploy-cloud.yml -u ubuntu -v


- Nuxeo and PostgreSQL on two hosts:

Edit the host names/IPs in hosts-cloud-multi
Hosts must be configured so you can connect to the ubuntu user with your ssh key.
Ubuntu user must have passwordless sudo.

ansible-playbook -i hosts-cloud-multi deploy-cloud.yml -u ubuntu -v


- Both in the same docker container:

Note: you must have a working local docker and docker-py installed.

ansible-playbook -i hosts-docker, deploy-docker.yml -u ubuntu -v

