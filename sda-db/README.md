# SDA Database

Source repository: https://github.com/neicnordic/sda-db 

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `default` section.  

Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | sda-db container image repository | `neicnordic/sda-db`
`image.tag` | sda-db  container image version | `"latest"`
`image.pullPolicy` | sda-db container image pull policy | `Always`
`rbacEnabled` | Use role based access control. |`true`
`revisionHistory` | Number of revisions to keep for the option to rollback a deployment | `3`
`updateStrategyType` | Update strategy type. | `RollingUpdate`
`networkPolicy.create` | Use network isolation. | `false`
`networkPolicy.matchLabels` | App labels that are allowed to connect to the database. | `app: sda-svc`
`securityPolicy.create` | Use pod security policy. | `true`
`global.pg_in_password` | Password for `lega_in` user, used for `data in` services. |`""`
`global.pg_out_password` | Password for `lega_out` user, used for `data out` services. |`""`
`global.verifyPeer` | Require client certificates. |`true`
`externalPkiService.tlsPath` | If an external PKI service is used, this is the path where the certifiates are placed | `""`
`persistence.enabled` | Enable persistence. | `true`
`persistence.mountPath` | Mountpoint for persistent volume. | `/var/lib/postgresql`
`persistence.storageSize` | Volume size. | `8Gi`
`persistence.storageClass` | Use specific storage class, by default dynamic provisioning enabled. | `null`
`persistence.existingClaim` | Use existing claim. | `null`
`persistence.volumePermissions` | Change the owner of the persist volume mountpoint to `RunAsUser:fsGroup`. | `true`
`service.type` | Database service type. |`ClusterIP`
`service.port` | Database service port. |`5432`
`resources.requests.memory` | Memory request for container. |`128Mi`
`resources.requests.cpu` | CPU request for container. |`100m`
`resources.limits.memory` | Memory limit for container. |`256Mi`
`resources.limits.cpu` | CPU limit for container. |`200m`
`podAnnotations` | Annotations applied to the pod |`{}`


### TLS

Certificates should be placed in the `files` folder and named accordingly.

- ca.crt, root ca certificate.
- pg.crt, serer certificate.
- pg.key, server key.

If you want `helm test` to work, you should also put

- tester.ca.key, private key used for tests
- tester.ca.crt, certificate for key, used for tests

in the same `files` folder.
