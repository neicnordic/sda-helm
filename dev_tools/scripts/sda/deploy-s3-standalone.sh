#!/bin/bash
set -e

if [ "$1" = "orchestrated" ]; then INTERCEPT=false; else INTERCEPT=true; fi
DB_IN_PASS=$(grep pg_in_password sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')
DB_OUT_PASS=$(grep pg_out_password sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')
S3_ACCESS_KEY=$(grep s3_archive_access_key sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')
S3_SECRET_KEY=$(grep s3_archive_secret_key sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')
C4GH_PASSPHRASE=$(grep ega_c4gh_passphrase sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')

helm install sda sda-svc -f dev_tools/config/s3.yaml \
--set global.archive.s3AccessKey="$S3_ACCESS_KEY",\
global.archive.s3SecretKey="$S3_SECRET_KEY",\
global.backupArchive.s3AccessKey="$S3_ACCESS_KEY",\
global.backupArchive.s3SecretKey="$S3_SECRET_KEY",\
global.broker.vhost=sda,\
global.c4gh.passphrase="$C4GH_PASSPHRASE",\
global.db.passIngest="$DB_IN_PASS",\
global.db.passOutgest="$DB_OUT_PASS",\
global.inbox.s3AccessKey="$S3_ACCESS_KEY",\
global.inbox.s3SecretKey="$S3_SECRET_KEY",\
global.schemaType=isolated,\
intercept.deploy=$INTERCEPT
