# Folder contents

This folder should contain the TLS certificates for orchestartor service and the root ca certificate.

- ca.crt, root ca certificate.
- orch.crt, service certificate.
- orch.key, service key.

If `customConfig` is enabled it expects a file with the name `config.json` so that it can load it as configuration from it.
