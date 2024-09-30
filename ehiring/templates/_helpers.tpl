{{/*
Expand the name of the chart.
*/}}
{{- define "ehiring.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ehiring.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ehiring.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ehiring.labels" -}}
helm.sh/chart: {{ include "ehiring.chart" . }}
{{ include "ehiring.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ehiring.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ehiring.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ehiring.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ehiring.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name port of the service
*/}}
{{- define "ehiring.frontend.port" -}}
{{- $serviceName := default .Chart.Name ( include "frontend.name" . ) -}}
{{- $customPort := .Values.service.port -}}
{{- if hasKey .Values $serviceName -}}
  {{- if hasKey (index .Values $serviceName) "port" -}}
    {{- $customPort = index .Values $serviceName "port" -}}
  {{- end -}}
{{- end -}}
{{- $port := default .Values.service.port $customPort -}}
{{- printf "%d" $port -}}
{{- end -}}

{{/*
Create the name port of the service
*/}}
{{- define "ehiring.backend-service.port" -}}
{{- $serviceName := default .Chart.Name ( include "backend-service.name" . ) -}}
{{- $customPort := .Values.service.port -}}
{{- if hasKey .Values $serviceName -}}
  {{- if hasKey (index .Values $serviceName) "port" -}}
    {{- $customPort = index .Values $serviceName "port" -}}
  {{- end -}}
{{- end -}}
{{- $port := default .Values.service.port $customPort -}}
{{- printf "%d" $port -}}
{{- end -}}

{{/*
Create the name host of the service
*/}}
{{- define "ehiring.frontend.host" -}}
{{- $serviceName := default .Chart.Name ( include "frontend.name" . ) -}}
{{- $customHost := .Values.service.host -}}
{{- if hasKey .Values $serviceName -}}
  {{- if hasKey (index .Values $serviceName) "host" -}}
    {{- $customHost = index .Values $serviceName "host" -}}
  {{- end -}}
{{- end -}}
{{- $host := default .Values.service.host $customHost -}}
{{- printf "%s" $host -}}
{{- end -}}

{{/*
Create the name host of the service
*/}}
{{- define "ehiring.backend-service.host" -}}
{{- $serviceName := default .Chart.Name ( include "frontend.name" . ) -}}
{{- $customHost := .Values.service.host -}}
{{- if hasKey .Values $serviceName -}}
  {{- if hasKey (index .Values $serviceName) "host" -}}
    {{- $customHost = index .Values $serviceName "host" -}}
  {{- end -}}
{{- end -}}
{{- $host := default .Values.service.host $customHost -}}
{{- printf "%s" $host -}}
{{- end -}}