#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Tests the installed release"""

import sys
import json
import argparse
import os
import ssl
import sys
import urllib.parse
from pathlib import Path

import pika

# Command-line arguments
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--connection', help="of the form 'amqp://<user>:<password>@<host>:<port>/<vhost>'")
parser.add_argument('--latest_message', action='store_true')
parser.add_argument('user')
parser.add_argument('inboxpath')
parser.add_argument('accessionid')
parser.add_argument('decsha256')
parser.add_argument('decmd5')
parser.add_argument('routing_key')
args = parser.parse_args()

exchange = os.getenv('MQ_EXCHANGE','sda')
mq_vhost = os.getenv('MQ_VHOST', '/').lstrip("/")

pki_path = os.getenv('PKI_PATH' '/certs')

env_connection = "amqps://%s:%s@%s/%s" % (
    os.getenv('MQ_USER', 'user'),
    os.getenv('MQ_PASSWORD', 'password'),
    os.getenv('MQ_HOST', 'mq'),
    urllib.parse.quote(mq_vhost, safe=''))


# MQ Connection
mq_connection = args.connection if args.connection else env_connection
parameters = pika.URLParameters(mq_connection)

if mq_connection.startswith('amqps'):

    context = ssl.SSLContext(protocol=ssl.PROTOCOL_TLS)  # Enforcing (highest) TLS version (so... 1.2?)

    context.check_hostname = False

    cacertfile = Path('%s/ca.crt' % pki_path)
    certfile = Path('%s/tester.ca.crt' % pki_path)
    keyfile = Path('%s/tester.ca.key' % pki_path)

    context.verify_mode = ssl.CERT_NONE
    # Require server verification
    if cacertfile.exists():
        context.verify_mode = ssl.CERT_REQUIRED
        context.load_verify_locations(cafile=str(cacertfile))

    # If client verification is required
    if certfile.exists():
        assert( keyfile.exists() )
        context.load_cert_chain(str(certfile), keyfile=str(keyfile))

    # Finally, the pika ssl options
    parameters.ssl_options = pika.SSLOptions(context=context, server_hostname=None)

connection = pika.BlockingConnection(parameters)
channel = connection.channel()

message = """
{
  "type": "accession",
  "user": "%s",
  "filepath": "%s",
  "accession_id": "%s",
  "decrypted_checksums": [
                         {
                          "type": "sha256",
                          "value": "%s"
                         },
                         {
                          "type": "md5",
                          "value": "%s"
                         }
                        ]
}
""" % (args.user,
       args.inboxpath,
       args.accessionid,
       args.decsha256,
       args.decmd5)

channel.basic_publish(exchange=exchange,
                      routing_key=args.routing_key,
                      body=message,
                      properties=pika.BasicProperties(correlation_id="1",
                                                      content_type='application/json',
                                                      delivery_mode=2))

connection.close()
