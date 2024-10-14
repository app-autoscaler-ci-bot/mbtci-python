# Use the base image
FROM devxci/mbtci-java21-node22@sha256:447fa9ee24ec5f66d46a69384a4b78d11da56d2bc7aebc0e06d57013bbee9160

LABEL org.opencontainers.image.source=https://github.com/autoscaler-ci-bot/mbtci-python
LABEL org.opencontainers.image.description="devxci/mbtci-java21-node22-based container image with Python 3 and pipx installed"
LABEL org.opencontainers.image.licenses=Apache-2.0

ARG MTA_USER="mta"

# Switch to root user to install packages
USER root

# Install python3

# renovate: datasource=python-version depName=python versioning=semver
ARG PYTHON_VERSION="3.13.0"

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
