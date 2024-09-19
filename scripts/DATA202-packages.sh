#!/bin/bash

# Install the common Python virtualenv IF it doesn't already exist
if [ ! -d "/opt/python" ]; then
  echo "Creating Python virtual environment in /opt/python"

  # first check to see if I have the python-packages script
  if [ ! -f "/scripts/python-packages.sh" ]; then
    echo "Downloading python-packages.sh into /scripts"
    curl -fsSL https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/python-packages.sh -o /scripts/python-packages.sh
    chmod 0755 /scripts/python-packages.sh
  fi

  # run the Python package installer
  bash /scripts/python-packages.sh
fi

# Install Quarto dependencies
apt update -y
apt install -y gdebi-core

# Install Quarto
export QUARTO_VERSION="1.5.56"
cd /tmp
wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
gdebi -n quarto-${QUARTO_VERSION}-linux-amd64.deb
rm -f quarto-${QUARTO_VERSION}-linux-amd64.deb

# add /usr/local/bin symlink
rm -f /usr/local/bin/quarto
ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto

# Cleanup
rm -rf /var/lib/apt/lists/*