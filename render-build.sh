#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências básicas
apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libpq-dev \
    libffi-dev \
    gcc

# Atualiza pip e ferramentas de build
python3 -m pip install --upgrade pip setuptools wheel

# Instala dependências do projeto
python3 -m pip install -r requirements.txt
