# Use the base image
FROM devxci/mbtci-java21-node22@sha256:480703fe6231eda9e78976d9a2a852bce4f144ee854ff1680f2adc8a581d7c7d

LABEL org.opencontainers.image.source=https://github.com/autoscaler-ci-bot/mbtci-python
LABEL org.opencontainers.image.description="devxci/mbtci-java21-node22-based container image with Python 3 and pipx installed"
LABEL org.opencontainers.image.licenses=Apache-2.0

ARG MTA_USER="mta"

# Switch to root user to install packages
USER root

# Install python3

# Automatic Python version updates via Renovate are currently disabled to keep the Python version in this Docker image  aligned with the version used by the Cloud Foundry python-buildpack, which has received no new releases as of 2025-10-16.
# Once the python-buildpack starts releasing newer Python versions, automatic Renovate updates can be re-enabled as shown here: https://github.com/app-autoscaler-ci-bot/mbtci-python/blob/d035e679b7f9e15e09e7c3e8a54946e409c938de/Dockerfile#L15
# The latest Python version supported by the last python-buildpack release (v1.8.38) is 3.13.5: https://github.com/cloudfoundry/python-buildpack/blob/v1.8.38/manifest.yml#L153
ARG PYTHON_VERSION="3.13.5"

# Install dependencies for building Python
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libbz2-dev \
    libdb5.3-dev \
    libexpat1-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
    wget \
    zlib1g-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and build Python from source
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

# Install pip and pipx
RUN python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip && \
    ln -s /usr/local/bin/pip3 /usr/local/bin/pip && \
    python3 -m pip install pipx && \
    python3 --version && pip --version && pipx --version

# Switch back to the original user
USER ${MTA_USER}
