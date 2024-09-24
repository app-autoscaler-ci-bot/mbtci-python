# mbtci-python
This repository contains a Dockerfile for building a Docker image based on [`devxci/mbtci-java21-node22`](https://hub.docker.com/r/devxci/mbtci-java21-node22) ([source](https://github.com/SAP/cloud-mta-build-tool/blob/master/Dockerfile_mbtci_template)) with Python installed from source. The image includes Python 3 and `pipx` for managing Python applications in isolated environments.

## Features
- Base image: `devxci/mbtci-java21-node22`
- Python 3 installed from source
- `pipx` installed for managing Python applications
- Automated dependency updates with Renovate

## Usage
```
docker pull ghcr.io/app-autoscaler-ci-bot/mbtci-python:latest
```