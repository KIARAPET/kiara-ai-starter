#!/usr/bin/env bash
set -o errexit

# Atualiza pacotes e instala dependências necessárias
apt-get update && apt-get install -y build-essential python3-dev libpq-dev gcc

# Atualiza pip e ferramentas básicas
python3 -m pip install --upgrade pip setuptools wheel

# Instala dependências do projeto
python3 -m pip install -r requirements.txt
