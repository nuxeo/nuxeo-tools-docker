# tests
Testing the IdP access, profile status, login, and IdP metadata content.
### container_tests.sh
Testing of the container based on [shunit2](https://github.com/kward/shunit2) framework.
### Dockerfile
A client image built **on-the-fly** for executing HTTP requests against the IdP server.  
It is used by the shunit2 tests.
### docker_compose.yml
The compose file used to run the image tests.
### docker-compose-alternate-ports.yml
The compose file used to run the alternate image tests double-checking changing the ports is correctly working.
### docker-compose-wait-for-sp.yml
The compose file used to manually test the SP registration.  
This requires an actual running SP.  
Simply issuing the following command against the IdP should trigger the SP registration:
```bash
wget --no-check-certificate "https://127.0.0.1:7443/idp/shibboleth"
```