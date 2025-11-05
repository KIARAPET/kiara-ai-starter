#!/usr/bin/env bash
set -o errexit

# Atualiza o pip e ferramentas
python3 -m pip install --upgrade pip setuptools wheel

# Instala dependências do projeto
pip install -r requirements.txt
