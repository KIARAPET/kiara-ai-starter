#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências de compilação
apt-get update && apt-get install -y build-essential python3-dev libpq-dev

# Atualiza o pip
python3 -m pip install --upgrade pip setuptools wheel

# Instala o asyncpg manualmente (com suporte ao libpq)
pip install --no-cache-dir asyncpg==0.29.0

# Instala o restante das dependências
pip install -r app/requirements.txt
