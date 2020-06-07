# Flask Admin Front End Template

![Tag](https://img.shields.io/github/v/tag/zack-klein/template-flask.svg) [![Build Status](https://travis-ci.com/zack-klein/template-flask.svg?branch=master)](https://travis-ci.com/zack-klein/template-flask) [![PyPI license](https://img.shields.io/pypi/l/ansicolortags.svg)](https://pypi.python.org/pypi/ansicolortags/)

This is a template repo for quick, minimal, simple flask-admin UI's. It comes with versioning, CI, gunicorn, Bootstrap, and SQLAlchemy all out of the box, as well as a simple setup for publishing these containers to GCR and ECR.


# Secret Management

This template leverages a tool called [`jana`](https://github.com/zack-klein/jana/tree/master/jana) that enables cross cloud compatibility for managing secrets. Right now, this repo supports storing secrets in AWS Secrets Manager and GCP Secret Manager. This repo expects a single JSON string with the secrets required just for this app. The semantic name for this secret should be stored with the environment variable:

```bash
export SECRET_STRING_NAME="your secret name"
```

Then, you should provide cloud-specific environment variables to configure fetching this secret.

## For AWS Secrets Manager:
```bash
export CLOUD_SERVICE_PROVIDER=aws
export SECRET_STRING_NAME="your secret name"
```

## For GCP Secret Manager
```bash
export CLOUD_SERVICE_PROVIDER=gcp
export SECRET_STRING_NAME="your secret name"
export GCP_PROJECT_NAME="your GCP project name"
export GCP_SECRET_VERSION="the version # of your secret"
```
