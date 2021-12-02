#!/bin/bash
set -e

helm install cega LocalEGA-helm/ega-charts/cega -f dev_tools/config/cega.yaml \
--set podSecurityPolicy.create=false,\
persistence.enabled=false
