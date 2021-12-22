#!/bin/bash
set -e

basedir="sda-deploy-init/config"

## cega config and certs
mkdir -p LocalEGA-helm/ega-charts/cega/config/certs
cp -r dev_tools/cega/* LocalEGA-helm/ega-charts/cega/config/
cp "${basedir}"/certs/ca.crt LocalEGA-helm/ega-charts/cega/config/certs/root.ca.crt
cp "${basedir}"/certs/cega-users.crt LocalEGA-helm/ega-charts/cega/config/certs/cega-users.ca.crt
cp "${basedir}"/certs/cega-users.key LocalEGA-helm/ega-charts/cega/config/certs/cega-users.ca.key
cp "${basedir}"/certs/cega-mq.crt LocalEGA-helm/ega-charts/cega/config/certs/cega-mq.crt
cp "${basedir}"/certs/cega-mq.key LocalEGA-helm/ega-charts/cega/config/certs/cega-mq.key

## sda-svc certs

kubectl create secret generic ca-root --from-file="${basedir}"/certs/ca.crt

for n in backup doa finalize inbox ingest intercept verify mapper auth tester
  do
  kubectl create secret tls $n-certs \
  --cert="${basedir}"/certs/$n.crt \
  --key="${basedir}"/certs/$n.key
done
