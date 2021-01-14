#!/bin/bash
set -e

# Workaround for some MacOS installations
#export PATH=$PATH:/home/ubuntu/.local/bin

if [ ! -d LocalEGA-helm ]; then
  git clone https://github.com/nbisweden/LocalEGA-helm
fi

if [ ! -d sda-deploy-init ]; then
  git clone https://github.com/neicnordic/sda-deploy-init
fi

pip3 install sda-deploy-init/ s3cmd

legainit --cega --config-path sda-deploy-init/config \
                 --svc-config dev_tools/config/svc.conf
