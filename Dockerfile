# Use the base image
FROM devxci/mbtci-java21-node22

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
