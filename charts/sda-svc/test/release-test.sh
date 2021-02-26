#!/bin/bash

if [ "${DEPLOYMENT_TOPOLOGY}" = "standalone" ]; then
  ingest_routing_key="files";
  accession_routing_key="files";
else
  ingest_routing_key="ingest";
  accession_routing_key="accessionIDs";
fi

export MQ_EXCHANGE=''

if [ "${DEPLOYMENT_TYPE}" = all -o "${DEPLOYMENT_TYPE}" = external ]; then

    python3 /release-test-app/verify-inboxes.py

    if [ "$?" -ne 0 ]; then
	echo "Failed inbox verification, bailing out"
	exit 1
    fi

    echo "Inbox seems okay"

    python3 /release-test-app/verify-doa.py

    if [ "$?" -ne 0 ]; then
	echo "Failed doa verification, bailing out"
	exit 1
    fi

    echo "DOA seems okay"

fi

if [ "${DEPLOYMENT_TYPE}" = external ] ; then
   echo "External-only deployment, nothing more to check."
   exit 0
fi

mkdir -p /tmp/c4gh

user=release-test-${RANDOM}

tmpfile=$(tempfile)
uploaded=${tmpfile##*/}.encrypted

echo "Creating file $tmpfile"

dd if=/dev/urandom of="$tmpfile" bs=1M count=16

echo "Creating c4gh key"
crypt4gh-keygen --sk /tmp/c4gh/key --pk /tmp/c4gh/key.pub --nocrypt -f

echo "Encrypting file"
crypt4gh encrypt --recipient_pk /release-test-app/c4gh.pub --sk /tmp/c4gh/key \
      < "$tmpfile" \
      > "${tmpfile}.encrypted"

echo "Noting checksums"
sha=$(sha256sum "${tmpfile}.encrypted" | cut -d' ' -f 1)
decsha=$(sha256sum "${tmpfile}" | cut -d' ' -f 1)
decmd=$(md5sum "${tmpfile}" | cut -d' ' -f 1)

echo
echo "Encrypted sha256: $sha"
echo "Decrypted sha256: $decsha"
echo "Decrypted md5: $decmd"
echo

if [ "${INBOX_STORAGE_TYPE}" = posix ]; then
    echo "Copying file $tmpfile to posix inbox"
    cp  "${tmpfile}.encrypted" /posix_inbox/
    ls -la "/posix_inbox/${uploaded}"
else

  cat - > /tmp/s3cmd.cfg <<EOF
[default]
access_key=${INBOX_ACCESSKEY}
secret_key=${INBOX_SECRETKEY}
check_ssl_certificate = True
encoding = UTF-8
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

  echo "Copying to s3://${INBOX_BUCKET}/${uploaded}"
  s3cmd  --region="${INBOX_REGION}" -c /tmp/s3cmd.cfg put  "${tmpfile}.encrypted" "s3://${INBOX_BUCKET}"

  echo "Waiting for s3 consistency"

  sleep 60
  s3cmd  --region="${INBOX_REGION}" -c /tmp/s3cmd.cfg ls "s3://${INBOX_BUCKET}/${uploaded}"

fi

count=0

echo "Trying to trigger ingestion by message through the routing key $ingest_routing_key"
until python3 /release-test-app/trigger-ingest.py "$user" "$uploaded" "$ingest_routing_key"; do
    echo "MQ failed, will wait and retry"
    sleep 10
    count=$((count+1))
    if [ "$count" -gt 10 ]; then
	echo "Could not send message after 100 s, bailing out"
	exit 1
    fi
done

# Fix db certs permissions
PGSSL=/tmp/pgcerts
mkdir -p "$PGSSL"

if [ -n "${DB_SSLMODE}" ]; then
    PGSSLMODE=${DB_SSLMODE}
    export PGSSLMODE
fi

PGSSLKEY=$PGSSL/postgresql.key
PGSSLCERT=$PGSSL/postgresql.crt
PGSSLROOTCERT=$PGSSL/root.crt
export PGSSLKEY PGSSLCERT PGSSLROOTCERT

s=${PKI_PATH:-/certs}

cp "$s/tester.ca.key" "$PGSSL/postgresql.key"
cp "$s/tester.ca.crt" "$PGSSL/postgresql.crt"
cp "$s/ca.crt" $PGSSL/root.crt

chmod -R og-rw $PGSSL

PGPASSWORD=${DB_PASSWORD}
export PGPASSWORD

echo "Will check in DB if file is archived"
echo
echo "Command used: psql -A -t  -h \"${DB_HOST}\" -U lega_in lega -c \
	 \"select archive_path from local_ega.files where
          inbox_file_checksum='$sha' and
          inbox_path='${uploaded}' and
          elixir_id='$user' and
          status in ('ARCHIVED', 'COMPLETED', 'READY');\""
echo
# psql -h "${DB_HOST}" -U lega_in lega

count=1
until archivepath=$(psql -A -t  -h "${DB_HOST}" -U lega_in lega -c \
	 "select archive_path from local_ega.files where
          inbox_file_checksum='$sha' and
          inbox_path='${uploaded}' and
          elixir_id='$user' and
          status in ('ARCHIVED', 'COMPLETED', 'READY');" | grep '.') || [ "$count" -ge 12 ]; do
    sleep 10;
    count=$((count+1));
done

if [ -z "$archivepath" ]; then
    echo "File did not show up in database after 2 minutes, giving up."
    exit 1
fi

echo "File was archived as $archivepath"

access=$(printf "EGAF%011d" "${RANDOM}${RANDOM}" )

echo "Will send an accession id message through the routing key $accession_routing_key"
until python3 /release-test-app/accession.py "$user" "$uploaded" "$access" "$decsha" "$decmd" "$accession_routing_key"; do
    sleep 10
    count=$((count+1))
    if [ "$count" -gt 10 ]; then
	echo "Could not send message after 100 seconds, giving up."
	exit 1
    fi
done


echo "Will check database for ready file"
echo
echo "Command used: psql -A -t  -h \"${DB_HOST}\" -U lega_in lega -c \
	 \"select archive_path from local_ega.files where
          inbox_file_checksum='$sha' and
          inbox_path='$uploaded' and
          stable_id='$access' and
          elixir_id='$user' and
          status='READY';\""
echo

count=0
until readypath=$(psql -A -t  -h "${DB_HOST}" -U lega_in lega -c \
	 "select archive_path from local_ega.files where
          inbox_file_checksum='$sha' and
          inbox_path='$uploaded' and
          stable_id='$access' and
          elixir_id='$user' and
          status='READY';" | grep '.') || [ "$count" -ge 12 ]; do
    sleep 10;
    echo "Not completed yet, will wait and retry"
    count=$((count+1));
done

echo
if [ -z "$readypath" ]; then
    echo "File did not show up as ready in database after 2 minutes, giving up."
    exit 1
fi

echo "File was ready - test succeeded"

echo
echo "Doing teardown"
echo

echo "Removing from database"
echo
psql -A -t  -h "${DB_HOST}" -U lega_in lega -c \
	 "delete from local_ega.files where
          inbox_file_checksum='$sha' and
          inbox_path='$uploaded' and
	  archive_path='$archivepath' and
          stable_id='$access' and
          elixir_id='$user' and
          status='READY';"

echo
if [ "${INBOX_STORAGE_TYPE}" = posix ]; then
    echo "Removing ${uploaded} from posix inbox if it's there"
    rm -f "/posix_inbox/${uploaded}"
else
  echo "Removing  s3://${INBOX_BUCKET}/${uploaded}"
  s3cmd  --region="${INBOX_REGION}" -c /tmp/s3cmd.cfg del "s3://${INBOX_BUCKET}/${uploaded}"
fi

if [ "${ARCHIVE_STORAGE_TYPE}" = posix ]; then
    echo "Removing $archivepath from posix archive if it's there"
    rm -f "/posix_archive/$archivepath"
else

  cat - > /tmp/s3cmd.cfg <<EOF
[default]
access_key=${ARCHIVE_ACCESSKEY}
secret_key=${ARCHIVE_SECRETKEY}
check_ssl_certificate = True
encoding = UTF-8
guess_mime_type = True
host_base = ${ARCHIVE_URL}
host_bucket = ${ARCHIVE_URL}
human_readable_sizes = True
multipart_chunk_size_mb = 5
use_https = True
socket_timeout = 30
EOF

  if [ -n "${ARCHIVE_CACERT}" ]; then
     echo "ca_certs_file = ${ARCHIVE_CACERT}" >> /tmp/s3cmd.cfg
  fi
  echo "Removing s3://${ARCHIVE_BUCKET}/$archivepath"
  s3cmd  --region="${ARCHIVE_REGION}" -c /tmp/s3cmd.cfg del "s3://${ARCHIVE_BUCKET}/$archivepath"
fi

exit 0

