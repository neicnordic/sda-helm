# SDA services

## Installing the Chart

Edit the values.yaml file and specify the relevant parts of the `defautl` section.  
If no shared credentials for the broker and database are used, the credentials for each service shuld be set in the `credentials` section.

Parameter | Description | Default
--------- | ----------- | -------
`global.pg_in_password` | Password for `lega_in` user, used for `data in` services. |`""`
`global.pg_out_password` | Password for `lega_out` user, used for `data out` services. |`""`
`global.verifyPeer` | Require client certificates. |`true`
`externalPkiService.tlsPath` | If an external PKI service is used, this is the path where the certifiates are placed | `""`

### TLS

Certificates should be placed in the `files` folder and named accordingly.

- CA.crt, root ca certificate.
- pg.crt, serer certificate.
- pg.key, server key.
