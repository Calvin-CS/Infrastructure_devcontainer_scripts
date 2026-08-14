#!/bin/bash

# Python 3.12 and PostgreSQL 16
apt update -y
apt install -y \
    python3.12 \
    python3-psycopg2 \
    python3-pytest \
    postgresql-16 \
    postgresql-client-common
rm -rf /var/lib/apt/lists/*

## gh cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
sudo mkdir -p -m 755 /etc/apt/keyrings
mkdir -p -m 755 /etc/apt/sources.list.d
# only download the keyring if it doesn't already exist
if [ ! -f /etc/apt/keyrings/githubcli-archive-keyring.gpg ]; then
    out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg
    cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    rm -f $out
fi
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
# only create the sources list if it doesn't already exist
if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi
sudo apt update
sudo apt install gh -y