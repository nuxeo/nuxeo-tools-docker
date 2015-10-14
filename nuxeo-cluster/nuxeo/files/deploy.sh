#!/bin/bash -e

cd /opt/nuxeo
mkdir -p conf data tmp

# Get distrib

if [ -n "$distribution" ]; then
    get-nuxeo-distribution -v $distribution -o nuxeo-distribution.zip
else
    get-nuxeo-distribution -o nuxeo-distribution.zip # lastbuild
fi

# Extract distrib and symlink to "server"

mkdir deploytmp
pushd deploytmp
unzip -q /opt/nuxeo/nuxeo-distribution.zip
dist=$(/bin/ls -1 | head -n 1)
mv $dist ../
popd
rm -rf deploytmp
ln -s $dist server
chmod +x server/bin/nuxeoctl

# Wait for Redis

until nc -q 1 redis 6379 < /dev/null; do
    sleep 1
done

# Configure

if [ -f /cluster-id ]; then
    clusterid=$(cat /cluster-id)
else
    clusterid=$(redis-cli -h redis --csv incr clusterid)
    echo -n $clusterid > /cluster-id
fi
printf "Cluster ID: %s\n" $clusterid

mkdir -p /logs/nuxeo/nuxeo$clusterid
chown -R nuxeo:nuxeo /logs/nuxeo/nuxeo$clusterid
chmod 0777 /logs
chmod 0777 /logs/nuxeo
chmod 0777 /logs/nuxeo/nuxeo$clusterid

if [ -d /share/binaries ]; then
    rm -rf /share/binaries
fi
mkdir -p /share/binaries
chown nuxeo:nuxeo /share/binaries
chmod 777 /share/binaries

if [ -d /share/transientstore ]; then
    rm -rf /share/transientstore
fi
mkdir -p /share/transientstore
chown nuxeo:nuxeo /share/transientstore
chmod 0777 /share/transientstore

if [ -d /opt/nuxeo/data/transientstores ]; then
    rm -rf /opt/nuxeo/data/transientstores
fi
mkdir -p /opt/nuxeo/data/transientstores
chown nuxeo:nuxeo /opt/nuxeo/data/transientstores
ln -s /share/transientstore /opt/nuxeo/data/transientstores/default

mv server/bin/nuxeo.conf conf/

# dirs
echo "nuxeo.data.dir=/opt/nuxeo/data" >> conf/nuxeo.conf
echo "nuxeo.tmp.dir=/opt/nuxeo/tmp" >> conf/nuxeo.conf
printf "nuxeo.log.dir=/logs/nuxeo/nuxeo%s\n" $clusterid >> conf/nuxeo.conf
# db
cat << EOF >> conf/nuxeo.conf
nuxeo.templates=postgresql-quartz-cluster
nuxeo.db.host=db
nuxeo.db.name=nuxeo
nuxeo.db.user=nuxeo
nuxeo.db.password=nuxeo
EOF
# clustering
echo "repository.clustering.enabled=true" >> conf/nuxeo.conf
printf "repository.clustering.id=%s\n" $clusterid >> conf/nuxeo.conf
echo "repository.binary.store=/share/binaries" >> conf/nuxeo.conf
printf "nuxeo.server.jvmRoute=intrapre%s\n" $clusterid >> conf/nuxeo.conf
# redis
cat << EOF >> conf/nuxeo.conf
nuxeo.redis.enabled=true
nuxeo.redis.host=redis
EOF
# elasticsearch
cat << EOF >> conf/nuxeo.conf
elasticsearch.addressList=es:9300
elasticsearch.clusterName=elasticsearch
elasticsearch.indexName=nuxeo
elasticsearch.indexNumberOfReplicas=0
audit.elasticsearch.enabled=true
audit.elasticsearch.indexName=audit
seqgen.elasticsearch.indexName=uidgen
EOF
# wizard
echo "nuxeo.wizard.done=true" >> conf/nuxeo.conf

if [ -f /deploy/conf ]; then
    cat /deploy/conf >> conf/nuxeo.conf
fi

if [ -f /deploy/instance.clid ]; then
    cp /deploy/instance.clid data/
fi

chown -R nuxeo:nuxeo /opt/nuxeo

nuxeoctl mp-init

if [ -d /deploy/mp-add ]; then
    for mp in $(/bin/ls /deploy/mp-add); do
        nuxeoctl mp-add /deploy/mp-add/$mp
    done
fi

if [ -f /deploy/mp-list ]; then
    mplist=$(cat /deploy/mp-list | tr '\n' ' ')
    nuxeoctl --accept=true --relax=false mp-install $mplist
fi

# TODO: manage custom templates

# Wait for PostgreSQL

until nc -q 1 db 5432 < /dev/null; do
    sleep 1
done

# Wait for Elasticsearch

until nc -q 1 es 9300 < /dev/null; do
    sleep 1
done

# Rolling nuxeo start

until [ "$(redis-cli --csv -h redis setnx nuxeo-starting 1)" == "1" ]; do
    echo "Waiting for other instance(s) to start..."
    sleep 5
done
redis-cli --csv -h redis expire nuxeo-starting 30 > /dev/null

nuxeoctl console

