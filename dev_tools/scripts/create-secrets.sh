#!/bin/bash
set -e

basedir="sda-deploy-init/config"

DB_IN=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DB_OUT=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

S3_Access=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
S3_Secret=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

G4GH=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

touch "${basedir}/trace.yml"

G4GH="${G4GH}" DB_IN="${DB_IN}" DB_OUT="${DB_OUT}" S3_Access="${S3_Access}" S3_Secret="${S3_Secret}" \
yq e -i '
  .secrets.c4gh_passphrase = strenv(G4GH) |
  .secrets.pg_in_password = strenv(DB_IN) |
  .secrets.pg_out_password = strenv(DB_OUT) |
  .secrets.s3_access_key = strenv(S3_Access) |
  .secrets.s3_secret_key = strenv(S3_Secret) 
' "${basedir}/trace.yml"

/usr/bin/expect <<EOD
spawn crypt4gh-keygen --sk c4gh.key --pk c4gh.pub
match_max 100000
expect -exact "Generating public/private Crypt4GH key pair.\r
Enter passphrase for c4gh.key (empty for no passphrase): "
send -- "$G4GH\r"
expect -exact "\r
Enter passphrase for c4gh.key (again): "
send -- "$G4GH\r"
expect eof
EOD

kubectl create secret generic c4gh --from-file=c4gh.key --from-file=c4gh.pub --from-literal=passphrase="${G4GH}"

# secret for the OIDC keypair
kubectl create secret generic oidc --from-file=sda-deploy-init/config/certs/token.key --from-file=sda-deploy-init/config/certs/token.pub
