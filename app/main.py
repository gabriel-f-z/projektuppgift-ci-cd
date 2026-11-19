import os

from fastapi import FastAPI, HTTPException

from app.service import add, divide

# The version is set when the Docker image is built (see Dockerfile, APP_VERSION).
# It lets us verify after a deploy or rollback which build is actually running.
APP_VERSION = os.getenv("APP_VERSION", "dev")

app = FastAPI(title="DevOps CI/CD Demo")


@app.get("/")
def root():
    return {"message": "DevOps CI/CD Demo"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/version")
def version():
    return {"version": APP_VERSION}


@app.get("/add")
def add_endpoint(a: float, b: float):
    return {"result": add(a, b)}


@app.get("/divide")
def divide_endpoint(a: float, b: float):
    try:
        return {"result": divide(a, b)}
    except ValueError as error:
        # A client error (bad input), not a server crash: answer 400 instead of 500.
        raise HTTPException(status_code=400, detail=str(error)) from error
