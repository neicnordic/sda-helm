#!/bin/bash
set -e

## S3 certs
cp sda-deploy-init/config/certs/s3.ca.crt public.crt
cp sda-deploy-init/config/certs/s3.ca.key private.key

## sda-orch certs
cp sda-deploy-init/config/certs/root.ca.crt charts/sda-orch/files/ca.crt
cp sda-deploy-init/config/certs/orchestrate.ca.crt charts/sda-orch/files/orch.crt
cp sda-deploy-init/config/certs/orchestrate.ca.key charts/sda-orch/files/orch.key

## sda-db certs
cp sda-deploy-init/config/certs/root.ca.crt charts/sda-db/files/ca.crt
cp sda-deploy-init/config/certs/db.ca.crt charts/sda-db/files/pg.crt
cp sda-deploy-init/config/certs/db.ca.key charts/sda-db/files/pg.key

## sda-mq certs
cp sda-deploy-init/config/certs/root.ca.crt charts/sda-mq/files/ca.crt
cp sda-deploy-init/config/certs/mq-server.ca.crt charts/sda-mq/files/server.crt
cp sda-deploy-init/config/certs/mq-server.ca.key charts/sda-mq/files/server.key

cp -r sda-deploy-init/config LocalEGA-helm/ega-charts/cega/config

## sda-svc certs
cp sda-deploy-init/config/token.pub charts/sda-svc/files/
cp sda-deploy-init/config/ega_key.c4gh.sec charts/sda-svc/files/c4gh.key
cp sda-deploy-init/config/ega_key.c4gh.pub charts/sda-svc/files/c4gh.pub
cp sda-deploy-init/config/certs/*.p12 charts/sda-svc/files/
cp sda-deploy-init/config/certs/cacerts charts/sda-svc/files/
cp sda-deploy-init/config/certs/root.ca.crt charts/sda-svc/files/ca.crt

for n in backup doa finalize ingest intercept verify mapper inbox
  do cp sda-deploy-init/config/certs/$n.ca.crt charts/sda-svc/files/"$(echo $n.ca.crt | cut -d '.' -f1,3)"
done

for n in backup doa finalize ingest intercept verify mapper inbox
  do cp sda-deploy-init/config/certs/$n.ca.key charts/sda-svc/files/"$(echo $n.ca.key | cut -d '.' -f1,3)"
done

cp sda-deploy-init/config/certs/res.ca.crt charts/sda-svc/files/auth.crt
cp sda-deploy-init/config/certs/res.ca.key charts/sda-svc/files/auth.key

for p in sda-svc sda-db sda-mq sda-orch
  do cp sda-deploy-init/config/certs/tester.ca.* "charts/$p/files/"
done
