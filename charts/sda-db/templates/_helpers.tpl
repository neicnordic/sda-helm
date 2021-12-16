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
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath .Values.global.tls.certName }}
    {{- end -}}
{{- end -}}

{{- define "pgKey" -}}
    {{- if .Values.externalPkiService.tlsPath }}
        {{- printf "%s" (regexReplaceAll "^/*|/+" (printf "%s/%s" .Values.externalPkiService.tlsPath .Values.global.tls.keyName) "/")}}
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath .Values.global.tls.keyName }}
    {{- end -}}
{{- end -}}

{{- define "caCert" -}}
    {{- if .Values.externalPkiService.tlsPath }}
        {{- printf "%s" (regexReplaceAll "^/*|/+" (printf "%s/%s" .Values.externalPkiService.tlsPath .Values.global.tls.CAFile) "/")}}
    {{- else }}
        {{- printf "%s/tls/%s" .Values.persistence.mountPath .Values.global.tls.CAFile }}
    {{- end -}}
{{- end -}}
