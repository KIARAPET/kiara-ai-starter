#!/usr/bin/env bash
set -o errexit

apt-get update && apt-get install -y build-essential python3-dev libpq-dev gcc

python3 -m pip install --upgrade pip setuptools wheel

python3 -m pip install --no-binary :all: asyncpg==0.29.0

python3 -m pip install -r requirements.txt
