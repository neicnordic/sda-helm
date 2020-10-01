#!/bin/bash

s=${PKI_PATH:-/certs}
mkdir -p /tmp/c4gh

dd if=/dev/urandom of=/tmp/testfile bs=1k count=16

crypt4gh-keygen --sk /tmp/c4gh/key --pk /tmp/c4gh/key.pub --nocrypt -f

crypt4gh encrypt --recipient_pk /testapp/c4gh.pub --sk /tmp/c4gh/key \
      < /tmp/testfile \
      > /tmp/testfile.encrypted

if [ "${STORAGE_TYPE}" = posix ]; then
   cp /tmp/testfile.encrypted /posix/
else

  cat - > /tmp/s3cmd.cfg <<EOF
[default]
access_key=${INBOX_ACCESSKEY}
secret_key=${INBOX_SECRETKEY}
check_ssl_certificate = True
encoding = UTF-8
encrypt = True
guess_mime_type = True
host_base = ${INBOX_URL}
host_bucket = ${INBOX_URL}
human_readable_sizes = True
multipart_chunk_size_mb = 5
use_https = True
socket_timeout = 30
EOF

  if [ -n "${INBOX_CACERT}" ]; then
     echo "ca_certs_file = ${INBOX_CACERT}" >> /tmp/s3cmd.cfg
  fi
  s3cmd  --region="${INBOX_REGION}" -c /tmp/s3cmd.cfg put /tmp/testfile.encrypted "s3://${INBOX_BUCKET}"
fi

count=0

until python3 /testapp/release-test.py; do
    sleep 10
    count=$((count+1))
    if [ "$count" -gt 10 ]; then
	break
    fi
done
