{{/*
Expand the name of the chart.
*/}}
{{- define "backend-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "backend-service.fullname" -}}
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
{{- define "backend-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "backend-service.labels" -}}
helm.sh/chart: {{ include "backend-service.chart" . }}
{{ include "backend-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backend-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backend-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "backend-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name image of the service
*/}}
{{- define "backend-service.imageName" -}}
{{- $serviceName := default .Chart.Name ( include "backend-service.name" . ) -}}
{{- $customRepo := "" -}}
{{- $customTag := "" -}}
{{- $customNamespace := "" -}}
{{- if hasKey .Values $serviceName -}}
  {{- if hasKey (index .Values $serviceName) "image" -}}
    {{- if hasKey (index .Values $serviceName "image") "repository" -}}
      {{- $customRepo = index .Values $serviceName "image" "repository" -}}
    {{- end -}}
    {{- if hasKey (index .Values $serviceName "image") "tag" -}}
      {{- $customTag = index .Values $serviceName "image" "tag" -}}
    {{- end -}}
    {{- if hasKey (index .Values $serviceName "image") "namespace" -}}
      {{- $customNamespace = index .Values $serviceName "image" "namespace" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- $name := default .Chart.Name (default .Values.image.repository $customRepo) -}}
{{- $tag := default .Values.image.tag $customTag -}}
{{- $namespace := default .Values.image.namespace $customNamespace -}}
{{- printf "%s/%s/%s:%s" .Values.image.registry $namespace $name $tag | quote -}}
{{- end -}}

{{/*
Create the env of the service
*/}}
{{- define "backend-service.env" -}}
{{- $globalEnv := .Values.global.backendService.env | default list }}
{{- $localEnv := .Values.env | default list }}
{{- $mergedEnv := list }}

{{- range $globalEnv }}
{{- $name := .name }}
{{- $value := .value }}
{{- $found := false }}
{{- range $localEnv }}
{{- if eq .name $name }}
{{- $value = .value }}
{{- $found = true }}
{{- end }}
{{- end }}
{{- if not $found }}
{{- $mergedEnv = append $mergedEnv (dict "name" $name "value" $value) }}
{{- end }}
{{- end }}

{{- range $localEnv }}
{{- $mergedEnv = append $mergedEnv . }}
{{- end }}

{{- range $mergedEnv }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end -}}

