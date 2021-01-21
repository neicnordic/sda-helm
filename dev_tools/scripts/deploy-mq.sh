#!/bin/bash
set -e

CEGA_MQ_PASS=$(grep cega_mq_pass sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')

helm install broker sda-mq \
--set securityPolicy.create=false,\
config.verifyPeer=false,\
config.adminUser=admin,\
config.adminPasswordHash=DI0kJIvQHptGSBH2coZ25dsjjN9Z4uxp8hAyqtd9H7rb/SBO,\
config.shovel.host=cega-mq,\
config.shovel.user=lega,\
config.shovel.pass="$CEGA_MQ_PASS",\
config.shovel.vhost=lega,\
config.vhost=sda
