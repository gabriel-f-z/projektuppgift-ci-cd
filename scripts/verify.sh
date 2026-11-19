#!/usr/bin/env bash
# Verify a deployment: wait until /health answers, then check /version.
# Usage: scripts/verify.sh <expected-version>
# Exits non-zero if the app is not healthy or runs the wrong version.
set -euo pipefail

EXPECTED_VERSION="${1:?usage: verify.sh <expected-version>}"
BASE_URL="${BASE_URL:-http://127.0.0.1:8000}"

echo "Waiting for ${BASE_URL}/health"
for attempt in $(seq 1 15); do
  if curl -fsS "${BASE_URL}/health" >/dev/null 2>&1; then
    echo "Health check OK (attempt ${attempt})"
    break
  fi
  if [ "${attempt}" -eq 15 ]; then
    echo "FAIL: /health did not respond" >&2
    exit 1
  fi
  sleep 2
done

ACTUAL=$(curl -fsS "${BASE_URL}/version")
echo "Version response: ${ACTUAL}"
if [ "${ACTUAL}" != "{\"version\":\"${EXPECTED_VERSION}\"}" ]; then
  echo "FAIL: expected version ${EXPECTED_VERSION}" >&2
  exit 1
fi
echo "OK: version ${EXPECTED_VERSION} is running"
