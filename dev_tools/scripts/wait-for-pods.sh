#!/bin/bash
set -e

if [ ! -z "$1" ]; then SVCNAME=$1; else SVCNAME="svc"; fi
if [ ! -z "$2" ]; then LABEL=$2; else LABEL="role"; fi
if [ ! -z "$3" ]; then NAMESPACE=$3; else NAMESPACE="default"; fi

for p in $SVCNAME
do
  RETRY_TIMES=0
  until kubectl get pods -n=$NAMESPACE -l=$LABEL=$p -o jsonpath='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status}' | grep "Ready=True"
  do
    echo "waiting for $p to become ready";
    RETRY_TIMES=$((RETRY_TIMES+1));
    if [ $RETRY_TIMES -eq 30 ]; then
      kubectl describe pod -n=$NAMESPACE -l=$LABEL=$p
      kubectl logs -n=$NAMESPACE -l=$LABEL=$p
      exit 1;
    fi
    sleep 10;
  done
done
