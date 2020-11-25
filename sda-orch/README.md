# SDA Orchestrate Service

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `config` section.  

Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | sda-orch container image repository | `neicnordic/sda-orch`
`image.tag` | sda-orch  container image version | `"latest"`
`image.pullPolicy` | sda-orch container image pull policy | `Always`
`logLevel` | sda-orch logging level | `info`
`global.tlsPath` | Default TLS path for certs and key in the pod. | `/tls/certs`
`revisionHistory` | Number of revisions to keep for the option to rollback a deployment | `3`
`podAnnotations` | Annotations applied to pods of all services. |`{}`
`pkiService` | If an external PKI infrastructure is used set this to true. |`false`
`pkiPermissions` | if permissions needs to be set on the injected certificates set this to true | `true`
`rbacEnabled` | Use role based access control. |`true`
`networkPolicy.create` | Use network isolation. | `false`
`podSecurityPolicy.create` | Use pod security policy. | `false`
`secretsService.create` | Use If secrets are managed externally. | `false`
`sslmode.ssl` | Enable SSL for MQ | `true`
`sslmode.verifyPeer` | Use Client/Server verification (used by MQ connection). | `true`
`broker.host` | Domain name or IP address to the message broker. |`""`
`broker.exchange` | Exchange to publish messages to. |`""`
`broker.port` | Port for the message broker. |`5671`
`broker.verifyPeer` |  | `true`
`broker.vhost` | Virtual host to connect to. | `/`
`broker.password` | Shared password to the message broker. | `""`
`broker.username` | Shared user to the message broker. | `""`
`broker.queue.inbox` | Inbox queue for MQ connection. | `""`
`broker.queue.completed` | Completed queue for MQ connection. | `""`
`broker.queue.verify` | Verify queue for MQ connection. | `""`
`broker.queue.stableid` | Accession IDs queue for MQ connection. | `""`
`broker.queue.files` | Files queue for MQ connection, general file operations. | `""`



### TLS

Certificates should be placed in the `files` folder and named accordingly.

- ca.crt, root ca certificate.
- orch.crt, serer certificate.
- orch.key, server key.
