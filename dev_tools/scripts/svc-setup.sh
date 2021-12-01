#!/bin/bash
set -e

basedir="sda-deploy-init/config"

## S3 certs
cp "${basedir}"/certs/public.crt public.crt
cp "${basedir}"/certs/private.key private.key

## sda-orch certs
cp "${basedir}"/certs/orch.crt charts/sda-orch/files/orch.crt
cp "${basedir}"/certs/orch.key charts/sda-orch/files/orch.key

## sda-db certs
kubectl create secret generic db-certs \
--from-file=root.crt="${basedir}"/certs/ca.crt \
--from-file=postgresql.crt="${basedir}"/certs/pg.crt \
--from-file=postgresql.key="${basedir}"/certs/pg.key

## sda-mq certs
cp "${basedir}"/certs/server.crt charts/sda-mq/files/server.crt
cp "${basedir}"/certs/server.key charts/sda-mq/files/server.key

## cega config and certs
mkdir -p LocalEGA-helm/ega-charts/cega/config/certs
cp -r dev_tools/cega/* LocalEGA-helm/ega-charts/cega/config/
cp "${basedir}"/certs/ca.crt LocalEGA-helm/ega-charts/cega/config/certs/root.ca.crt
cp "${basedir}"/certs/cega-users.crt LocalEGA-helm/ega-charts/cega/config/certs/cega-users.ca.crt
cp "${basedir}"/certs/cega-users.key LocalEGA-helm/ega-charts/cega/config/certs/cega-users.ca.key
cp "${basedir}"/certs/cega-mq.crt LocalEGA-helm/ega-charts/cega/config/certs/cega-mq.crt
cp "${basedir}"/certs/cega-mq.key LocalEGA-helm/ega-charts/cega/config/certs/cega-mq.key

## sda-svc certs
cp "${basedir}"/certs/token.pub charts/sda-svc/files/
cp "${basedir}"/c4gh.key charts/sda-svc/files/c4gh.key
cp "${basedir}"/c4gh.pub charts/sda-svc/files/c4gh.pub
cp "${basedir}"/certs/*.p12 charts/sda-svc/files/
cp "${basedir}"/certs/cacerts charts/sda-svc/files/

for n in backup doa finalize ingest intercept verify mapper inbox auth 
  do
  cp "${basedir}"/certs/$n.crt charts/sda-svc/files/$n.crt
  cp "${basedir}"/certs/$n.key charts/sda-svc/files/$n.key
done

for p in sda-svc sda-mq sda-orch
  do 
  cp "${basedir}"/certs/ca.crt "charts/$p/files/ca.crt"
  cp "${basedir}"/certs/tester.* "charts/$p/files/"
done
