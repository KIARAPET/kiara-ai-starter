#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências de compilação
apt-get update && apt-get install -y build-essential python3-dev libpq-dev gcc

# Atualiza pip e ferramentas
python3 -m pip install --upgrade pip setuptools wheel

# Instala o asyncpg com cache limpo
python3 -m pip install --no-binary :all: asyncpg==0.29.0

# Instala o restante das dependências
python3 -m pip install -r requirements.txt
