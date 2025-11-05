#!/usr/bin/env bash
set -o errexit

# Atualiza ferramentas de pacote para evitar surpresas
python3 -m pip install --upgrade pip setuptools wheel

# Instala as libs do projeto (sem apt-get, sem compilar nada)
pip install -r requirements.txt
