#!/bin/bash
set -e

## create empty files so the linter won't give an false error

if [ $1 = "sda-db" ] || [ $1 = "sda-mq" ]; then
touch $1/files/ca.crt
touch $1/files/server.crt
fi
