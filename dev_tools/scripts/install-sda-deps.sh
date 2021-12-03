#!/bin/bash
set -e

YQ_VERSION=v4.14.2
YQ_BINARY=yq_linux_amd64
# Workaround for some MacOS installations
#export PATH=$PATH:/home/ubuntu/.local/bin

if [ ! -d LocalEGA-helm ]; then
  git clone https://github.com/nbisweden/LocalEGA-helm
fi

# install s3cmd and crypt4gh
pip install s3cmd crypt4gh

# install expect
sudo apt-get install -y expect 

# install yq for creating secrets
sudo wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq &&\
    sudo chmod +x /usr/bin/yq
