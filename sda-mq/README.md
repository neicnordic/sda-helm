# SDA Message broker

Source repository: https://github.com/neicnordic/LocalEGA-mq

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `config` section.  

Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | sda-mq container image repository | `neicnordic/sda-mq`
`image.tag` | sda-mq  container image version | `"latest"`
`image.pullPolicy` | sda-mq container image pull policy | `Always`
`config.adminUser` | Username of admin user |`""`
`config.adminPasswordHash` | Passwordhash for admin user. |`""`
`config.verifyPeer` | Require client certificates. |`true`
`config.vhost` | default vhost is '/' unless specifically named |`""`
`config.shovel.host` | Hostname of federated server |`""`
`config.shovel.pass` | Password to federated server |`""`
`config.shovel.port` | Port that federated server listens on |`5671`
`config.shovel.user` | Username to federated server |`""`
`config.shovel.vhost` | Vhost on federated sever to connect to |`""`
`externalPkiService.tlsPath` | If an external PKI service is used, this is the path where the certifiates are placed | `""`
`rbacEnabled` | Use role based access control. |`true`
`revisionHistory` | Number of revisions to keep for the option to rollback a deployment | `3`
`updateStrategyType` | Update strategy type. | `RollingUpdate`
`networkPolicy.create` | Use network isolation. | `false`
`networkPolicy.matchLabels` | App labels that are allowed to connect to the Message broker. | `app: sda-svc`
`securityPolicy.create` | Use pod security policy. | `true`
`persistence.enabled` | Enable persistence. | `true`
`persistence.storageSize` | Volume size. | `8Gi`
`persistence.storageClass` | Use specific storage class, by default dynamic provisioning enabled. | `null`
`persistence.existingClaim` | Use existing claim. | `null`
`persistence.volumePermissions` | Change the owner of the persist volume mountpoint to `RunAsUser:fsGroup`. | `true`
`service.type` | Message broker service type. |`ClusterIP`
`service.port` | Message broker service port. |`5671`
`resources.requests.memory` | Memory request for container. |`128Mi`
`resources.requests.cpu` | CPU request for container. |`100m`
`resources.limits.memory` | Memory limit for container. |`256Mi`
`resources.limits.cpu` | CPU limit for container. |`200m`
`podAnnotations` | Annotations applied to the pod. |`{}`

### TLS

Certificates should be placed in the `files` folder and named accordingly.

- ca.crt, root ca certificate.
- server.crt, serer certificate.
- server.key, server key.
