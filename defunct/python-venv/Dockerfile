FROM ubuntu:noble
LABEL maintainer="Chris Wieringa <cwieri39@calvin.edu>"

# Set versions and platforms
ARG BUILDDATE=20240821-1
ARG TZ=America/Detroit

# Do all run commands with bash
SHELL ["/bin/bash", "-c"] 

##################################
## Start with base Ubuntu
##################################

# Start with some base packages and APT setup
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    gpg \
    locales \
    lsb-release \
    nano \
    software-properties-common \
    tar \
    tofrodos \
    unzip \
    vim \
    vim-nox \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Calvin cpscadmin repo keys
RUN echo "deb [signed-by=/usr/share/keyrings/csrepo.gpg] http://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/ noble main" | tee -a /etc/apt/sources.list.d/cs-ubuntu-software-noble.list && \
    curl https://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/csrepo.asc | tee /tmp/csrepo.asc && \
    gpg --dearmor /tmp/csrepo.asc && \
    mv /tmp/csrepo.asc.gpg /usr/share/keyrings/csrepo.gpg && \
    rm -f /tmp/csrepo.asc

##################################
## Container configuration
##################################

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone

# Add CalvinAD trusted root certificate
ADD https://raw.githubusercontent.com/Calvin-CS/Infrastructure_configs/main/auth/CalvinCollege-ad-CA.crt /etc/ssl/certs/
RUN chmod 0644 /etc/ssl/certs/CalvinCollege-ad-CA.crt && \
    ln -s -f /etc/ssl/certs/CalvinCollege-ad-CA.crt /etc/ssl/certs/ddbc78f4.0

# Add a /scripts directory for class includes
RUN mkdir -p /scripts

# Locale and Environment configuration
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm-256color \
    TZ=${TZ}

##################################
## Python Virtual Env
##################################

# Install system dependencies
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    libtiff5-dev \
    libjpeg8-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.6-dev \
    tk8.6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    && rm -rf /var/lib/apt/lists/*

# Python
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* 

# Setup a Python virtual environment
ADD packages-list /scripts/packages-list
RUN python3 -m venv --symlinks /opt/python
RUN source /opt/python/bin/activate && \
    pip3 install \
    `cat /scripts/packages-list | xargs` && \
    pip freeze > /opt/python/requirements.txt && \
    deactivate

# Cleanup misc files
RUN rm -f /var/log/*.log && \
    rm -f /var/log/apt/* && \
    rm -f /var/log/faillog

##################################
## Final Container settings
##################################
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT [ "/usr/bin/cat", "/opt/python/requirements.txt" ]