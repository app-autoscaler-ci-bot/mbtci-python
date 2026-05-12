# Use the base image
FROM devxci/mbtci-java21-node22@sha256:1f76a8031a9d1fcec4ff0c71cbcd648768c76712b2aa304356ffd212b820b477

LABEL org.opencontainers.image.source=https://github.com/autoscaler-ci-bot/mbtci-python
LABEL org.opencontainers.image.description="devxci/mbtci-java21-node22-based container image with Python 3 and pipx installed"
LABEL org.opencontainers.image.licenses=Apache-2.0

ARG MTA_USER="mta"

# Switch to root user to install packages
USER root

# Install python3

# renovate: datasource=python-version depName=python versioning=semver
ARG PYTHON_VERSION="3.14.5"

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
    python3 -m pip install pipx && \
    ln -sf $(which pip3) /usr/local/bin/pip && \
    python3 --version && pip --version && pipx --version

# Switch back to the original user
USER ${MTA_USER}
