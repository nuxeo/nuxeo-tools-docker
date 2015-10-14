*Temporary unformatted doc*

Deploys a Nuxeo cluster infrastructure in docker with:
- a Apache load-balancer with Apache-managed affinity
- two Nuxeo nodes
- a PostgreSQL node
- an ElasticSearch node
- a Redis node
The final deployment is exposed on port 8080.


By default, PostgreSQL, ES and Redis are used.

The deployed Nuxeo can be customized:
- for the distribution, by changing the environment variable in docker-compose
- config parameter overrides can be specified in deploy/conf
- custom addons can be made available in deploy/mp-add/
- list of addons to install can be specified in deploy/mp-list

For instance, if you don't want to use redis, you can add "nuxeo.redis.enabled=false" to deploy/conf (the redis container will still be started).


Requirements:
- docker
- docker-compose

