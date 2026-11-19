"""Integration tests: real HTTP calls against the running Docker container.

Run with:  BASE_URL=http://127.0.0.1:8000 python -m pytest -m integration
"""

import os

import httpx
import pytest

pytestmark = pytest.mark.integration

BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000")
EXPECTED_VERSION = os.getenv("EXPECTED_VERSION")


def get(path: str) -> httpx.Response:
    return httpx.get(f"{BASE_URL}{path}", timeout=5)


def test_health():
    response = get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_add():
    response = get("/add?a=2&b=3")
    assert response.status_code == 200
    assert response.json() == {"result": 5.0}


def test_version():
    response = get("/version")
    assert response.status_code == 200
    if EXPECTED_VERSION:
        assert response.json() == {"version": EXPECTED_VERSION}


def test_divide_by_zero_returns_400():
    response = get("/divide?a=1&b=0")
    assert response.status_code == 400
