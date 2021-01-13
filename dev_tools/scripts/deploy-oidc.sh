#!/bin/bash
set -e

pushd sda-helm

kubectl apply -f .github/ci_tests/oidc.yaml

popd
