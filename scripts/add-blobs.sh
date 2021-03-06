#!/usr/bin/env bash

set -eo pipefail -u -x

version=1.7.11
sha256=68332497361cbb694545833c7efb1f569db48a0e5265fad7ca75c91b900c3faa

if [[ ! -f "traefik-${version}_linux-amd64" && ! -f "traefik-${version}_linux-amd64.gz" ]]; then
    curl -L "https://github.com/containous/traefik/releases/download/v$version/traefik_linux-amd64" \
        -o "traefik-${version}_linux-amd64"
    shasum -a 256 --check <<< "${sha256}  traefik-${version}_linux-amd64"
fi

if [[ -f "traefik-${version}_linux-amd64" && ! -f "traefik-${version}_linux-amd64.gz" ]]; then
    gzip -9 "traefik-${version}_linux-amd64"
fi

blob_path="traefik/traefik-${version}_linux-amd64.gz"
set +o pipefail
if ! bosh blobs | grep -q "${blob_path}"; then
    bosh add-blob "traefik-${version}_linux-amd64.gz" "${blob_path}"
fi
