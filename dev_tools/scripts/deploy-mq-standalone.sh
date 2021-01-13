#!/bin/bash
set -e

pushd sda-helm


helm install broker sda-mq \
--set securityPolicy.create=false,\
config.adminUser=admin,\
config.adminPasswordHash="DI0kJIvQHptGSBH2coZ25dsjjN9Z4uxp8hAyqtd9H7rb/SBO",\
config.vhost=sda

popd
