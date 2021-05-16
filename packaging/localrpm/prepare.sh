#!/bin/sh -euf
set -euxo pipefail

#COMMIT_SHORT=$(git rev-parse --short=8 HEAD)
VERSION := $(cat ./VERSION)

mkdir -p build/
#git archive --prefix "podman-${COMMIT_SHORT}/" --format "tar.gz" HEAD -o "build/podman-${COMMIT_SHORT}.tar.gz"
git archive --prefix "podman-${VERSION}/" --format "tar.gz" HEAD -o "build/podman-${VERSION}.tar.gz"