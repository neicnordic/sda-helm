#!/usr/bin/env python3

import os
import socket
import ssl
import sys
import urllib.request

backendtype = os.environ.get('INBOX_STORAGE_TYPE','s3')
backendhost = os.environ.get('INBOX_SERVICE_NAME','localhost')


if backendtype == 'posix':
    # Connect and see that we get a ssh greeting
    s = socket.socket()

    print("Will try connecting to %s:2222" % backendhost)
    s.connect( (backendhost, 2222), )
    hello = s.recv(8)

    if hello != b'SSH-2.0-':
        sys.exit(1)
    sys.exit(0)
    
if backendtype == 's3':
    print("Will try connecting to https://%s/" % backendhost)

    try:
        r = urllib.request.urlopen('https://%s/' % backendhost,
                                context=ssl._create_unverified_context())

        sys.exit(0)
    except urllib.error.HTTPError as e:
        if e.code == 403:
            # 403 is okay here
            sys.exit(0)
        print("Unexpected error talking to doa: \n\n%s" % e)

sys.exit(1)

