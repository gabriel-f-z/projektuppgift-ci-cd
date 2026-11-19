#!/usr/bin/env bash
# Roll back to an earlier version by starting its EXISTING image (no rebuild).
# Usage: scripts/rollback_local.sh <previous-version>   e.g. scripts/rollback_local.sh v1
set -euo pipefail

VERSION="${1:?usage: rollback_local.sh <previous-version>}"
IMAGE_NAME="${IMAGE_NAME:-projektuppgift-ci-cd}"
CONTAINER_NAME="${CONTAINER_NAME:-projektuppgift-app}"
PORT="${PORT:-8000}"

# Rollback is only possible if the old image still exists.
if ! docker image inspect "${IMAGE_NAME}:${VERSION}" >/dev/null 2>&1; then
  echo "FAIL: image ${IMAGE_NAME}:${VERSION} not found, cannot roll back" >&2
  exit 1
fi

echo "Rolling back to ${IMAGE_NAME}:${VERSION}"
docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run -d --name "${CONTAINER_NAME}" -p "${PORT}:8000" "${IMAGE_NAME}:${VERSION}"

echo "Rolled back to ${VERSION}"
