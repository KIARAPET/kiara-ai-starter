# Imagem base estável
FROM python:3.11-slim

# Configurações padrão do Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Diretório de trabalho dentro do container
WORKDIR /app

# Pacotes do SO necessários para compilar libs (asyncpg, etc.)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Copia requirements primeiro (melhora cache)
COPY requirements.txt .

# Atualiza ferramentas Python e instala dependências com pins estáveis
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install "Cython<3.0" "asyncpg==0.29.0" \
 && pip install -r requirements.txt

# Copia o restante do projeto
COPY . .

# Porta de execução
EXPOSE 10000

# Comando de start
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "10000"]
