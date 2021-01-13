#!/bin/bash
set -e

pushd sda-helm

ls -la LocalEGA-helm/ega-charts/cega/config

cat LocalEGA-helm/ega-charts/cega/config/trace.yml

helm install cega LocalEGA-helm/ega-charts/cega -f LocalEGA-helm/ega-charts/cega/config/trace.yml \
--set podSecurityPolicy.create=false,\
persistence.enabled=false

popd
