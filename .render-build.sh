#!/usr/bin/env bash
# Script de build para Render
apt-get update && apt-get install -y build-essential
pip install --upgrade pip
pip install -r requirements.txt
