#!/bin/bash
set -e

## create empty files so the linter won't give an false error
touch sda-db/files/ca.crt
touch sda-db/files/server.crt
