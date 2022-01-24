#!/usr/bin/env python3

import os
import ssl
import sys
import urllib.request
import urllib.error


backendhost = os.environ.get("DOA_SERVICE_NAME", "localhost")

print(f"Will try connecting to {backendhost}:443")

try:
    r = urllib.request.urlopen(f"https://{backendhost}:443/files", context=ssl._create_unverified_context())
    sys.exit(0)
except urllib.error.HTTPError as e:
    if e.code == 404:
        # 404 is okay here
        sys.exit(0)
    print("Unexpected error talking to doa: \n\n%s" % e)

sys.exit(1)
