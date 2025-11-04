#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências do sistema
apt-get update && apt-get install -y build-essential libpq-dev gcc

# Atualiza o pip e ferramentas de build
python3 -m pip install --upgrade pip setuptools wheel

# Força a compilação correta do asyncpg
python3 -m pip install --no-binary :all: asyncpg==0.29.0

# Instala as demais dependências do app
python3 -m pip install -r requirements.txt
