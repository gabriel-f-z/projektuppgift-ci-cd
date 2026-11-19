# projektuppgift-ci-cd

A small FastAPI calculator API with a GitHub Actions CI/CD chain: lint and unit/API tests → Docker build and integration tests → simulated deploy with verification. Local rollback via `scripts/`.

Run locally: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && python -m pytest`
Container + rollback: `scripts/deploy_local.sh v1 && scripts/verify.sh v1`, then `scripts/rollback_local.sh v1` after deploying v2.
