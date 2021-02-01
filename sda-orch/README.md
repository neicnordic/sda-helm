# SDA Orchestrate Service

Source repositories: https://github.com/neicnordic/sda-orchestrator

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
`vaultSecrets` | Use If Hasicort Vault is used for secrets management. | `false`
`sslmode.ssl` | Enable SSL for MQ | `true`
`sslmode.verifyPeer` | Use Client/Server verification (used by MQ connection). | `true`
`broker.host` | Domain name or IP address to the message broker. |`""`
`broker.exchange` | Exchange to publish messages to. |`""`
`broker.port` | Port for the message broker. |`5671`
`broker.verifyPeer` |  | `true`
`broker.vhost` | Virtual host to connect to. | `/`
`broker.password` | Shared password to the message broker. | `""`
`broker.username` | Shared user to the message broker. | `""`
`broker.queue.inbox` | Inbox queue for MQ connection. | `inbox`
`broker.queue.completed` | Completed queue for MQ connection. | `completed`
`broker.queue.verify` | Verify queue for MQ connection. | `verify`
`broker.queue.accessionids` | Accession IDs queue for MQ connection. | `accessionIDs`
`broker.queue.mapping` | Mappings for Accession IDs to DatasetIDs queue for MQ connection. | `mappings`
`datasetID.external` | If the DatasetIDs will be used by external system set this to `true`  | `false`
`datasetID.useCustomConfig` | If a custom config is used set this value to `true`. Using custom configuration expects a file under the name `config.json` in `files` folder. | `false`
`datasetID.datacite.apiURL` | Datacite API URL  | `""`
`datasetID.datacite.user` |  Datacite API user  | `""`
`datasetID.datacite.key` | Datacite API key  | `""`
`datasetID.datacite.prefix` | Datacite DOI prefix. Only one prefix can be used at this time. | `""`
`datasetID.rems.apiURL` | REMS API URL  | `""`
`datasetID.rems.user` |  REMS API user. Resources will belong to this user by default. | `""`
`datasetID.rems.key` |  REMS API key | `""`

### TLS

Certificates should be placed in the `files` folder and named accordingly.

- ca.crt, root ca certificate.
- orch.crt, serer certificate.
- orch.key, server key.
