#!/usr/bin/env bash
# Build an image for VERSION and (re)start the app container from it.
# Usage: scripts/deploy_local.sh <version>     e.g. scripts/deploy_local.sh v2
set -euo pipefail

VERSION="${1:?usage: deploy_local.sh <version>}"
IMAGE_NAME="${IMAGE_NAME:-projektuppgift-ci-cd}"
CONTAINER_NAME="${CONTAINER_NAME:-projektuppgift-app}"
PORT="${PORT:-8000}"

echo "Building ${IMAGE_NAME}:${VERSION}"
docker build --build-arg APP_VERSION="${VERSION}" -t "${IMAGE_NAME}:${VERSION}" .

echo "Replacing container ${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run -d --name "${CONTAINER_NAME}" -p "${PORT}:8000" "${IMAGE_NAME}:${VERSION}"

echo "Deployed ${IMAGE_NAME}:${VERSION} on port ${PORT}"
