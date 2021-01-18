#!/bin/bash
set -e

helm repo add minio https://helm.min.io/
helm repo update

kubectl create secret generic minio-certs --from-file=public.crt --from-file=private.key

MINIO_ACCESS=$(grep s3_archive_access_key sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')
MINIO_SECRET=$(grep s3_archive_secret_key sda-deploy-init/config/trace.yml | awk '{print $2}' | sed -e 's/\"//g')

helm install minio minio/minio \
--set accessKey="$MINIO_ACCESS",secretKey="$MINIO_SECRET",\
tls.enabled=true,tls.certSecret=minio-certs,\
persistence.enabled=false,service.port=443 --version 8.0.8
