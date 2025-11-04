#!/usr/bin/env bash
set -o errexit

# Use Python 3.10 (combina com o runtime.txt)
python3 -m pip install --upgrade pip

# asyncpg precisa de build; esta linha força wheels/compilação correta no Render
python3 -m pip install --no-binary :all: asyncpg==0.29.0

# Instala o restante das dependências
python3 -m pip install -r app/requirements.txt
