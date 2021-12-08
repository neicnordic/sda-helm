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

for n in backup finalize ingest intercept verify mapper auth 
  do
  kubectl create secret generic $n-certs \
  --from-file="${basedir}"/certs/ca.crt \
  --from-file="${basedir}"/certs/$n.crt \
  --from-file="${basedir}"/certs/$n.key
done

for m in doa inbox
  do
  kubectl create secret generic $m-certs \
  --from-file="${basedir}"/certs/ca.crt \
  --from-file="${basedir}"/certs/$m.crt \
  --from-file="${basedir}"/certs/$m.key \
  --from-file="${basedir}"/certs/$m.key.der \
  --from-file="${basedir}"/certs/$m.p12 \
  --from-file="${basedir}"/certs/cacerts
done

# secret for the OIDC keypair
kubectl create secret generic oidc --from-file="${basedir}"/certs/token.key --from-file="${basedir}"/certs/token.pub

# secret for the release testers certificates
kubectl create secret generic tester-certs \
--from-file="${basedir}"/certs/tester.key \
--from-file="${basedir}"/certs/tester.crt \
--from-file="${basedir}"/certs/ca.crt
