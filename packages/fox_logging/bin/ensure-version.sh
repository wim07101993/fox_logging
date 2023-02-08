#!/bin/bash

if ! command -v dotnet-gitversion &> /dev/null
then
  >&2 echo "[error] GitVersion not found in path (dotnet-gitversion). Please make sure the application is installed. (https://gitversion.net/docs/usage/cli/installation)"
  exit 1
fi

FULL_SEM_VER=$(dotnet-gitversion | grep -Po '"FullSemVer": "\K[^"]+')
YAML_VERSION=$(grep -oP 'version: "?\K[^"]+' "$1")

if [ "$FULL_SEM_VER" == "$YAML_VERSION" ]
then
  exit 0
else
  >&2 echo "[error] Expected version $FULL_SEM_VER, got $YAML_VERSION in $1"
  exit 2
fi