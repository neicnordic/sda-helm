#!/bin/bash
set -e

## create empty files so the linter won't give an false error

if [ $1 = "sda-db" ] || [ $1 = "sda-mq" ]; then
touch $1/files/ca.crt
touch $1/files/server.crt
fi

if [ $1 = "sda-orch" ]; then
touch $1/files/root.ca.crt
touch $1/files/cert.ca.crt
touch $1/files/cert.ca.key
fi

if [ $1 = "sda-svc" ]; then
for n in ca doa finalize inbox ingest interceptor verify
do
touch $1/files/$n.crt
done

for n in cacerts doa.p12 inbox.p12 c4gh.key jwt.key
do
touch $1/files/$n
done

fi
