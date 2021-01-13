#!/bin/bash
set -e

pushd sda-helm

kubectl apply -f dev_tools/config/oidc.yaml

popd
