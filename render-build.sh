#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências necessárias
apt-get update && apt-get install -y \
  build-essential \
  python3-dev \
  libpq-dev \
  gcc \
  pkg-config \
  libffi-dev

# Garante que pip e ferramentas estão atualizados
python3 -m pip install --upgrade pip setuptools wheel Cython

# Instala manualmente asyncpg com precompilação
python3 -m pip install --no-cache-dir asyncpg==0.29.0

# Instala as demais dependências do projeto
python3 -m pip install -r requirements.txt
