#!/bin/bash

# Python 3.12 and PostgreSQL 16
apt update -y
apt install -y \
    python3.12 \
    python3-psycopg2 \
    postgresql-16 \
    postgresql-client-common
rm -rf /var/lib/apt/lists/*