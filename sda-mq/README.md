# SDA Message broker

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `config` section.  

Parameter | Description | Default
--------- | ----------- | -------
`config.adminUser` | Username of admin user |`""`
`config.adminPasswordHash` | Passwordhash for admin user. |`""`
`config.verifyPeer` | Require client certificates. |`true`
`config.vhost` | default vhost |`"/"`
`config.shovel.host` | Hostname of federated server |`""`
`config.shovel.pass` | Password to federated server |`""`
`config.shovel.port` | Port that federated server listens on |`5671`
`config.shovel.user` | Username to federated server |`""`
`config.shovel.vhost` | Vhost on federated sever to connect to |`""`
`externalPkiService.tlsPath` | If an external PKI service is used, this is the path where the certifiates are placed | `""`

### TLS

Certificates should be placed in the `files` folder and named accordingly.

- ca.crt, root ca certificate.
- server.crt, serer certificate.
- server.key, server key.
