#!/bin/bash
set -e

pushd sda-helm

DB_IN_PASS=$(grep pg_in_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
DB_OUT_PASS=$(grep pg_out_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')

helm install postgres sda-db \
--set securityPolicy.create=false,\
global.pg_in_password="$DB_IN_PASS",\
global.pg_out_password="$DB_OUT_PASS",\
global.verifyPeer=false

popd
