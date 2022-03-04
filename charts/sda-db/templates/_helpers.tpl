{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sda.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "sda.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sda.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pgInPassword" -}}
    {{- ternary (randAlphaNum 12) .Values.global.pg_in_password (empty .Values.global.pg_in_password) -}}
{{- end -}}

{{- define "pgOutPassword" -}}
    {{- ternary (randAlphaNum 12) .Values.global.pg_out_password (empty .Values.global.pg_out_password) -}}
{{- end -}}

{{- define "pgCert" -}}
    {{- if .Values.externalPkiService.tlsPath }}
        {{- printf "%s" (regexReplaceAll "^/*|/+" (printf "%s/%s" .Values.externalPkiService.tlsPath .Values.global.tls.certName) "/")}}
    {{- else if or .Values.global.tls.clusterIssuer .Values.global.tls.issuer }}
        {{- printf "%s/tls/tls.crt" .Values.persistence.mountPath -}}
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath (required "name of tls certificate is required" .Values.global.tls.certName) }}
    {{- end -}}
{{- end -}}

{{- define "pgKey" -}}
    {{- if .Values.externalPkiService.tlsPath }}
        {{- printf "%s" (regexReplaceAll "^/*|/+" (printf "%s/%s" .Values.externalPkiService.tlsPath .Values.global.tls.keyName) "/")}}
    {{- else if or .Values.global.tls.clusterIssuer .Values.global.tls.issuer }}
        {{- printf "%s/tls/tls.key" .Values.persistence.mountPath -}}
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath (required "name of tls key is required" .Values.global.tls.keyName) }}
    {{- end -}}
{{- end -}}

{{- define "caCert" -}}
    {{- if .Values.externalPkiService.tlsPath }}
        {{- printf "%s" (regexReplaceAll "^/*|/+" (printf "%s/%s" .Values.externalPkiService.tlsPath .Values.global.tls.CAFile) "/")}}
    {{- else if or .Values.global.tls.clusterIssuer .Values.global.tls.issuer }}
        {{- printf "%s/tls/ca.crt" .Values.persistence.mountPath -}}
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath (required "name of ca file is required" .Values.global.tls.CAFile) }}
    {{- end -}}
{{- end -}}

{{- define "TLSissuer" -}}
    {{- if and .Values.global.tls.clusterIssuer .Values.global.tls.issuer }}
        {{- fail "Only one of global.tls.issuer or global.tls.clusterIssuer should be set" }}
    {{- end -}}

    {{- if and .Values.global.tls.issuer }}
        {{- printf "%s" .Values.global.tls.issuer }}
    {{- else if and .Values.global.tls.clusterIssuer }}
        {{- printf "%s" .Values.global.tls.clusterIssuer }}
    {{- end -}}
{{- end -}}

{{- define "TLSsecret" -}}
    {{- if and .Values.global.tls.enabled (not .Values.externalPkiService.tlsPath) }}
        {{- if and (not .Values.global.tls.issuer) (not .Values.global.tls.clusterIssuer) }}
            {{ printf "%s" (required "TLS secret name is required when TLS in enabled without issuer or PKI service" .Values.global.tls.secretName) }}
        {{- else }}
            {{- printf "%s-certs" (include "sda.fullname" .) }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "testTLSsecret" -}}
    {{- if and .Values.global.tls.enabled (not .Values.externalPkiService.tlsPath) }}
        {{- if and (not .Values.global.tls.issuer) (not .Values.global.tls.clusterIssuer) }}
            {{ printf "%s" (required "TLS secret name is required when TLS in enabled without issuer or PKI service" .Values.testimage.tls.secretName) }}
        {{- else }}
            {{- printf "%s-test-certs" (include "sda.fullname" .) }}
        {{- end -}}
    {{- end -}}
{{- end -}}
