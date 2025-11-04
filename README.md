# Kiara AI – Starter Kit (FastAPI + Postgres)

Backend da Kiara AI (MVP) pronto para deploy no Render e banco Neon.

## Endpoints
- `GET /health` – healthcheck
- `POST /score` – calcula Kiara Score (V1 – regras)
- `POST /recommendations` – retorna score + recomendações

## Como rodar localmente
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# rodar
uvicorn app.main:app --reload
```

## Variáveis de ambiente
Crie `.env` (ou defina no Render):
- `DATABASE_URL` – URL do Postgres (ex.: Neon)
- `SECRET_KEY` – chave aleatória (ex.: `openssl rand -hex 32`)

## Deploy no Render
1. Faça fork deste repositório para a sua conta GitHub **KIARAPET**.
2. No Render: **New Web Service** → conecte o repo.
3. Environment: **Python 3.11**
4. Build Command: `pip install -r requirements.txt`
5. Start Command: `uvicorn app.main:app --host 0.0.0.0 --port 10000`
6. Plano: **Free**
7. Add env vars: `DATABASE_URL`, `SECRET_KEY`
8. Teste: `https://<seu-servico>.onrender.com/health`

## DNS (Hostinger)
Crie um **CNAME**:
- Nome: `api`
- Destino: `<seu-servico>.onrender.com`
Depois acesse: `https://api.kiarapet.app/health`

## Teste rápido
```bash
curl -X POST https://api.kiarapet.app/score   -H 'Content-Type: application/json'   -d '{ "species": "dog", "birthdate": "2021-10-01", "weight_kg": 12.0,
        "activity_level": "low",
        "health_history": [
          {"record_type": "vaccine", "name":"V10", "occurred_at":"2025-03-20"},
          {"record_type": "checkup", "name":"Anual", "occurred_at":"2024-12-01"}
        ] }'
```
