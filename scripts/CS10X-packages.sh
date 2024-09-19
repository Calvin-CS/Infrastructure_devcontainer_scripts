#!/bin/bash

# Install the common Python virtualenv IF it doesn't already exist
if [ ! -d "/opt/python" ]; then
  echo "Creating Python virtual environment in /opt/python"

  # first check to see if I have the python-packages script
  if [ ! -f "/scripts/python-packages.sh" ]; then
    echo "Downloading python-packages.sh into /scripts"
    curl -fsSL https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer_scripts/main/scripts/python-packages.sh -o /scripts/python-packages.sh
    chmod 0755 /scripts/python-packages.sh
  fi
  # run the Python package installer
  bash /scripts/python-packages.sh
fi