#!/usr/bin/env bash
set -o errexit

# Pacotes do sistema necessários para compilar dependências (asyncpg, etc.)
apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  python3-dev \
  libpq-dev \
  libffi-dev \
  gcc

# Ferramentas Python e Cython (usado na compilação)
python3 -m pip install --upgrade pip setuptools wheel Cython

# Gera wheel local do asyncpg para evitar "failed-wheel-build-for-install"
python3 -m pip install --no-binary :all: "asyncpg==0.29.0"

# Demais libs do projeto
python3 -m pip install -r requirements.txt
