#!/bin/bash

# Note: CS10X, DATA202, and other classes need a variety of Python packages.
# Make a common virtualenv that can support them all. Additionally, 

# Install system dependencies
apt update -y && \
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
apt update -y 
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* 

# Setup a Python virtual environment
python3 -m venv --symlinks /opt/python
source /opt/python/bin/activate

# Download requirements.txt and install all of them
# Note to update the requirements.txt file
curl -fsSL https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer_scripts/main/scripts/requirements.txt -o /tmp/requirements.txt
pip3 install -r /tmp/requirements.txt
rm -f /tmp/requirements.txt
deactivate

# add PYTHONPATH environment variable
cat >/etc/profile.d/pythonpath.sh <<EOL
#!/bin/sh

export VIRTUAL_ENV=/opt/python
export VIRTUAL_ENV_PROMPT=(python)
export PATH=/opt/python/bin:$PATH
export WORKON_HOME=/opt

EOL
chmod 0755 /etc/profile.d/pythonpath.sh