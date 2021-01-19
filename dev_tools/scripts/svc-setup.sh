#!/bin/bash
set -e

## S3 certs
cp sda-deploy-init/config/certs/s3.ca.crt public.crt
cp sda-deploy-init/config/certs/s3.ca.key private.key

## sda-orch certs
cp sda-deploy-init/config/certs/root.ca.crt sda-orch/files/ca.crt
cp sda-deploy-init/config/certs/orchestrate.ca.crt sda-orch/files/orch.crt
cp sda-deploy-init/config/certs/orchestrate.ca.key sda-orch/files/orch.key

## sda-db certs
cp sda-deploy-init/config/certs/root.ca.crt sda-db/files/ca.crt
cp sda-deploy-init/config/certs/db.ca.crt sda-db/files/pg.crt
cp sda-deploy-init/config/certs/db.ca.key sda-db/files/pg.key

## sda-mq certs
cp sda-deploy-init/config/certs/root.ca.crt sda-mq/files/ca.crt
cp sda-deploy-init/config/certs/mq-server.ca.crt sda-mq/files/server.crt
cp sda-deploy-init/config/certs/mq-server.ca.key sda-mq/files/server.key

cp -r sda-deploy-init/config LocalEGA-helm/ega-charts/cega/config

## sda-svc certs
cp sda-deploy-init/config/token.pub sda-svc/files/
cp sda-deploy-init/config/ega_key.c4gh.sec sda-svc/files/c4gh.key
cp sda-deploy-init/config/ega_key.c4gh.pub sda-svc/files/c4gh.pub
cp sda-deploy-init/config/certs/*.p12 sda-svc/files/
cp sda-deploy-init/config/certs/cacerts sda-svc/files/
cp sda-deploy-init/config/certs/root.ca.crt sda-svc/files/ca.crt

for n in backup doa finalize ingest intercept verify mapper inbox
  do cp sda-deploy-init/config/certs/$n.ca.crt sda-svc/files/"$(echo $n.ca.crt | cut -d '.' -f1,3)"
done

for n in backup doa finalize ingest intercept verify mapper inbox
  do cp sda-deploy-init/config/certs/$n.ca.key sda-svc/files/"$(echo $n.ca.key | cut -d '.' -f1,3)"
done

cp sda-deploy-init/config/certs/res.ca.crt sda-svc/files/auth.crt
cp sda-deploy-init/config/certs/res.ca.key sda-svc/files/auth.key
