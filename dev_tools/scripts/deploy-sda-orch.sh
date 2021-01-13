#!/bin/bash
set -e

pushd sda-helm

DB_IN_PASS=$(grep pg_in_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
DB_OUT_PASS=$(grep pg_out_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')

helm install orch sda-orch \
--set podSecurityPolicy.create=false,\
broker.password="admin",\
broker.username=admin,\
broker.host="broker-sda-mq",\
broker.exchange="sda",\
broker.vhost="sda",\
broker.queue.inbox="inbox",\
broker.queue.completed="completed",\
broker.queue.verify="archived",\
broker.queue.files="files",\
broker.queue.stabledid="accessionIDs",\
db.host="postgres-sda-db",\
db.passIngest="$DB_IN_PASS",\
db.passOutgest="$DB_OUT_PASS"

popd
