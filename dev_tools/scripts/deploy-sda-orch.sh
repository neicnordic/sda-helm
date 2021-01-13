#!/bin/bash
set -e

pushd sda-helm

DB_IN_PASS=$(grep pg_in_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')
DB_OUT_PASS=$(grep pg_out_password sda-deploy-init/config/trace.yml | awk {'print $2'} | sed --expression 's/\"//g')

helm install orch sda-orch -f .github/ci_tests/orch.yaml \
--set db.passIngest="$DB_IN_PASS",\
db.passOutgest="$DB_OUT_PASS"

popd
