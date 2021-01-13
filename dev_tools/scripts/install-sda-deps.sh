#!/bin/bash
set -e

# Workaround for some MacOS installations
#export PATH=$PATH:/home/ubuntu/.local/bin

if [[ ! -d sda-helm ]]; then
  git clone https://github.com/neicnordic/sda-helm
fi

pushd sda-helm

if [[ ! -d LocalEGA-helm ]]; then
  git clone https://github.com/nbisweden/LocalEGA-helm
fi

if [[ ! -d sda-deploy-init ]]; then
  git clone https://github.com/neicnordic/sda-deploy-init
fi

pip3 install sda-deploy-init/

legainit --cega --config-path sda-deploy-init/config \
                 --svc-config .github/ci_tests/svc.conf

popd
