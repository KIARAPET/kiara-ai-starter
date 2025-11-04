#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências necessárias para compilar asyncpg
apt-get update && apt-get install -y build-essential python3-dev libpq-dev gcc

# Atualiza pip e ferramentas
pip install --upgrade pip setuptools wheel

# Instala as dependências do projeto
pip install -r requirements.txt
