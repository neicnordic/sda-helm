#!/bin/bash
set -e

CEGA_MQ_PASS=$(grep cega_mq_pass sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')

## sda-mq certs
kubectl create secret generic mq-certs \
--from-file=sda-deploy-init/config/certs/ca.crt \
--from-file=sda-deploy-init/config/certs/server.crt \
--from-file=sda-deploy-init/config/certs/server.key


helm install broker charts/sda-mq \
--set securityPolicy.create=false,\
config.adminUser=admin,\
config.adminPasswordHash=DI0kJIvQHptGSBH2coZ25dsjjN9Z4uxp8hAyqtd9H7rb/SBO,\
config.shovel.host=cega-mq,\
config.shovel.user=lega,\
config.shovel.pass="$CEGA_MQ_PASS",\
config.shovel.vhost=lega,\
config.vhost=sda,\
config.tls.secretName=mq-certs,\
config.tls.serverKey=server.key,\
config.tls.serverCert=server.crt,\
config.tls.caCert=ca.crt,\
config.tls.verifyPeer=true,\
testimage.tls.secretName=mq-certs,\
testimage.tls.tlsKey=server.key,\
testimage.tls.tlsCert=server.crt,\
testimage.tls.caCert=ca.crt
