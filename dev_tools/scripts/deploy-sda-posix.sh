#!/bin/bash
set -e

pushd sda-helm

CEGA_USERS_PASS=$(grep cega_users_pass sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
DB_IN_PASS=$(grep pg_in_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
DB_OUT_PASS=$(grep pg_out_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
C4GH_PASSPHRASE=$(grep ega_c4gh_passphrase sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')

helm install sda sda-svc -f dev_tools/config/posix.yaml \
--set global.c4gh.passphrase="$C4GH_PASSPHRASE",\
global.cega.password="$CEGA_USERS_PASS",\
global.db.passIngest="$DB_IN_PASS",\
global.db.passOutgest="$DB_OUT_PASS",\

popd
