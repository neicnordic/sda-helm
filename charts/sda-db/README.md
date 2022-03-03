# SDA Database

Source repository: [https://github.com/neicnordic/sda-db](https://github.com/neicnordic/sda-db)

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `global` section.

Parameter | Description | Default
--------- | ----------- | -------
`global.pg_in_password` | Password for `lega_in` user, used for `data in` services. |`""`
`global.pg_out_password` | Password for `lega_out` user, used for `data out` services. |`""`
`global.tls.enabled` | Enable TLS for all connections. |`true`
`global.tls.secretName` | Name of the secret holding the certificates. |``
`global.tls.certName` | Server certificate. |`postgresql.crt`
`global.tls.keyName` | Server private key. |`postgresql.key`
`global.tls.CAFile` | CA root certificate. |`root.crt`
`global.tls.verifyPeer` | Require client certificates. |`verify-ca`
`externalPkiService.tlsPath` | If an external PKI service is used, this is the path where the certifiates are placed | `""`
`image.repository` | sda-db container image repository | `ghcr.io/neicnordic/sda-db`
`image.tag` | sda-db  container image version | `v1.4.0`
`image.pullPolicy` | sda-db container image pull policy | `IfNotPresent`
`networkPolicy.create` | Use network isolation. | `false`
`networkPolicy.matchLabels` | App labels that are allowed to connect to the database. | `app: sda-svc`
`persistence.enabled` | Enable persistence. | `true`
`persistence.mountPath` | Mountpoint for persistent volume. | `/var/lib/postgresql`
`persistence.storageSize` | Volume size. | `8Gi`
`persistence.storageClass` | Use specific storage class, by default dynamic provisioning enabled. | `null`
`persistence.existingClaim` | Use existing claim. | `null`
`persistence.volumePermissions` | Change the owner of the persist volume mountpoint to `RunAsUser:fsGroup`. | `true`
`podAnnotations` | `"key": "value"` list of annotations for the pod (optional) | `{}`
`port` | Port the application will listen to (optional) | `5432`
`postgresAdminPassword` | PostgreSQL admin password (optional) | `""`
`rbacEnabled` | Use role based access control. |`true`
`resources.requests.memory` | Memory request for container. |`128Mi`
`resources.requests.cpu` | CPU request for container. |`100m`
`resources.limits.memory` | Memory limit for container. |`256Mi`
`resources.limits.cpu` | CPU limit for container. |`200m`
`revisionHistory` | Number of revisions to keep for the option to rollback a deployment | `3`
`updateStrategyType` | Update strategy type. | `RollingUpdate`
`securityPolicy.create` | Use pod security policy. | `true`
`service.type` | Database service type. |`ClusterIP`
`service.port` | Database service port. |`5432`

### TLS

Create a secret that contains the certificates

```cmd
kubectl create secret generic ca-secret \
--from-file=root.crt=ca.crt \
--from-file=postgresql.crt=server.crt \
--from-file=postgresql.key=server.key
```
