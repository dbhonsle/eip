#!/bin/sh -euf
set -euxo pipefail

VERSION=$(cat ./VERSION)

mkdir -p build/
git archive --prefix "eip-${VERSION}/" --format "tar.gz" HEAD -o "build/eip-${VERSION}.tar.gz"

