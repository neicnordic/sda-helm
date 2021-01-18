#!/bin/bash
set -e

helm install cega LocalEGA-helm/ega-charts/cega -f LocalEGA-helm/ega-charts/cega/config/trace.yml \
--set podSecurityPolicy.create=false,\
persistence.enabled=false
