# SDA services

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `global` section.  
If no shared credentials for the broker and database are used, the credentials for each service shuld be set in the `credentials` section.

### Configuration

The following table lists the configurable parameters of the `sda-svc` chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`global.secretsPath` |  | `/etc/ega`
`global.c4ghPath` |  | `""`
`global.tlsPath` |  | `""`
`global.deploymentType` | Deployment can be split into `external` and `internal` components, available options are `all`, `external` and `internal`. | `all`
`global.ingress.deploy` |  | `false`
`global.ingress.hostName.doa` |  | `""`
`global.ingress.hostName.s3Inbox` |  | `""`
`global.ingress.secretNames.doa` | The name of a manually created secret holding the certificates for the ingrewss enpoint. | `""`
`global.ingress.secretNames.s3Inbox` | The name of a manually created secret holding the certificates for the ingrewss enpoint. | `""`
`global.ingress.issuer` | If cert-manager is set up to request certificates to the ingress endpoints, the configured issuer can be specified to automate certificate configuration for the ingress endpoint. | `""`
`global.log` | Log level for all services. | `info`
`global.networkPolicy.create` | Use network isolation. | `false`
`global.networkPolicy.brokerNamespace` | Namespace where the broker is deployed. | `""`
`global.networkPolicy.databaseNamespace` | Namespace where the database is deployed. | `""`
`global.networkPolicy.externalNamespace` | Namespace where the external components are deployed. | `""`
`global.networkPolicy.internalNamespace` | Namespace where the internal components are deployed. | `""`
`global.persistence.enabled` | Enable persistent datastorage | `true`
`global.revisionHistory` | Number of revisions to keep for the option to rollback a deployment | `3`
`global.podAnnotations` | Annotations applied to pods of all services. |`{}`
`global.pkiService` | If an external PKI infrastructure is used set this to true. |`false`
`global.rbacEnabled` | Use role based access control. |`true`
`global.archive.storageType` | Storage type for the data archive, available options are `S3Storage` and `FileStorage`. |`S3Storage`
`global.archive.s3Url` | URL to S3 archive instance. |`""`
`global.archive.s3Bucket` | S3 archive bucket. |`""`
`global.archive.s3Region` | S3 archive region. |`us-east-1`
`global.archive.s3ChunkSize` | S3 chunk size in MB. |`15`
`global.archive.s3AccessKey` | Access key to S3 archive . |`""`
`global.archive.s3SecretKey` | Secret key to S3 archive. |`""`
`global.archive.s3CaFile` | CA certificate to use if the S3 archive is internal. |`""`
`global.archive.s3Port` | Port that the S3 S3 archive is available on. |`443`
`global.archive.volumePath` | Path to the mounted `FileStorage` volume. |`/ega/archive`
`global.archive.volumeMode` | File mode on the `FileStorage` volume. |`2750`
`global.archive.nfsServer` | URL or IP addres to a NFS server. |`""`
`global.archive.nfsPath` | Path on the NFS server for the archive. |`""`
`global.broker.host` | Domain name or IP address to the message broker. |`""`
`global.broker.exchange` | Exchange to publish messages to. |`""`
`global.broker.port` | Port for the message broker. |`5671`
`global.broker.verifyPeer` | Use Client/Server verification. |`true`
`global.broker.vhost` | Virtual host to connect to. |`/`
`global.broker.password` | Shared password to the message broker. |`/`
`global.broker.username` | Shared user to the message broker. |`/`
`global.cega.host` | Domain name for the EGA user authentication service. |`""`
`global.cega.user` | Username for the EGA user authentication service. |`""`
`global.cega.password` | Password for the EGA user authentication service. |`""`
`global.c4gh.file` | Private C4GH key. |`c4gh.key`
`global.c4gh.passphrase` | Passphrase for the private C4GH key. |`""`
`global.db.host` | Hostname for the database. |`""`
`global.db.name` | Database to connect to. |`lega`
`global.db.passIngest` | Password used for `data in` services. |`""`
`global.db.passOutgest` | Password used for `data out` services. |`""`
`global.db.port` | Port that the database is listening on. |`5432`
`global.db.sslMode` | SSL mode for the database connection, options are `verify-ca` or `verify-full`. |`verify-full`
`global.doa.serviceport` | Port that the DOA service is accessible on | `443`
`global.elixir.pubKey` | Public key used to verify Elixir JWT. | `""`
`global.inbox.brokerRoutingKey` | Routing key the inbox uses when publishing messages. | `files.inbox"`
`global.inbox.servicePort` | The port that the inbox is accessible via. | `2222`
`global.inbox.storageType` | Storage type for the inbox. |`FileStorage`
`global.inbox.path` | Path to the mounted `FileStorage` volume. |`/ega/archive`
`global.inbox.user` | Path to the mounted `FileStorage` volume. |`lega`
`global.inbox.nfsServer` | URL or IP addres to a NFS server. |`""`
`global.inbox.nfsPath` | Path on the NFS server for the archive. |`""`
`global.inbox.existingClaim` | Existing volume to use for the `fileStorage` inbox. | `""`

### Credentials

If no shared credentials for the message broker and database are used these should be set in the `credentials` section of the values file.

Parameter | Description | Default
--------- | ----------- | -------
`credentials.doa.dbUser` | Databse user for doa | `""`
`credentials.doa.dbPassword` | Database password for doa| `""`
`credentials.finalize.dbUser` | Databse user for finalize | `""`
`credentials.finalize.dbPassword` | Database password for finalize | `""`
`credentials.finalize.mqUser` | Broker user for finalize | `""`
`credentials.finalize.mqPassword` | Broker password for finalize | `""`
`credentials.inbox.mqUser` | Broker user for inbox | `""`
`credentials.inbox.mqPassword` | Broker password for inbox | `""`
`credentials.ingest.dbUser` | Databse user for ingest | `""`
`credentials.ingest.dbPassword` | Database password for ingest | `""`
`credentials.ingest.mqUser` | Broker user for ingest  | `""`
`credentials.ingest.mqPassword` | Broker password for ingest | `""`
`credentials.verify.dbUser` | Databse user for verify | `""`
`credentials.verify.dbPassword` | Database password for verify | `""`
`credentials.verify.mqUser` | Broker user for verify | `""`
`credentials.verify.mqPassword` | Broker password for verify | `""`

### Pod settings

Parameter | Description | Default
--------- | ----------- | -------
`doa.replicaCount` | desired number of replicas | `1`
`doa.repository` | dataedge container image repository | `neicnordic/sda-doa`
`doa.imageTag` | dataedge container image version | `"latest"`
`doa.imagePullPolicy` | dataedge container image pull policy | `Always`
`doa.keystorePass` | keystore password | `changeit`
`doa.annotations` | Specific annotation for doa | `{}`
`finalize.repository` | inbox container image repository | `neicnordic/sda-base`
`finalize.imageTag` | inbox container image version | `latest`
`finalize.imagePullPolicy` | inbox container image pull policy | `Always`
`finalize.annotations` | Specific annotation for finalize | `{}`
`ingest.repository` | inbox container image repository | `neicnordic/sda-base`
`ingest.imageTag` | inbox container image version | `latest`
`ingest.imagePullPolicy` | inbox container image pull policy | `Always`
`ingest.replicaCount` | desired number of ingest workers | `1`
`ingest.annotations` | Specific annotation for ingest | `{}`
`sftpInbox.repository` | inbox container image repository | `neicnordic/sda-inbox-sftp`
`sftpInbox.imageTag` | inbox container image version | `latest`
`sftpInbox.imagePullPolicy` | inbox container image pull policy | `Always`
`sftpInbox.replicaCount`| desired number of sftpInbox containers | `1`
`sftpInbox.keystorePass` | sftpInbox keystore password | `changeit`
`sftpInbox.nodeHostname` | Node name if the sftp inbox  needs to be deployed on a specific node | `""`
`sftpInbox.annotations` | Specific annotation for sftpInbox | `{}`
`verify.repository` | inbox container image repository | `neicnordic/sda-base`
`verify.imageTag` | inbox container image version | `latest`
`verify.imagePullPolicy` | inbox container image pull policy | `Always`
`verify.replicaCount`| desired number of verify containers | `1`
`verify.annotations` | Specific annotation for verify | `{}`
