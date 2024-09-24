# Use the base image
FROM devxci/mbtci-java21-node22@sha256:9320babf01013bfa04262f5c2d78adc93ec5ac684ae01497c8bcd3b94a9bbaeb

LABEL org.opencontainers.image.source=https://github.com/autoscaler-ci-bot/mbtci-python
LABEL org.opencontainers.image.description="devxci/mbtci-java21-node22-based container image with Python 3 and pipx installed"
LABEL org.opencontainers.image.licenses=Apache-2.0

ARG MTA_USER="mta"

# Switch to root user to install packages
USER root

# Install python3, pip, pipx
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install pipx && \
    python3 --version && pip --version && pipx --version

# Switch back to the original user
USER ${MTA_USER}
