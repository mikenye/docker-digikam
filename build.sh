#!/usr/bin/env sh

# Quit on error, show operations
set -xe

# Repo/Image name
REPO=mikenye
IMAGE=digikam

# Build on x86_64
docker context use x86_64

# Build latest
docker build -t "${REPO}/${IMAGE}:latest" --compress --pull .

# Get version from latest
VERSION=$(docker run --rm --entrypoint cat ${REPO}/${IMAGE}:latest /VERSIONS | grep digikam | cut -d " " -f 2)

# Build version-specific
docker build -t "${REPO}/${IMAGE}:${VERSION}" --compress --pull .

# Push
docker push "${REPO}/${IMAGE}:${VERSION}"
docker push "${REPO}/${IMAGE}:latest"