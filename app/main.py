from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import date, datetime

app = FastAPI(title="Kiara AI – MVP")

class HealthEvent(BaseModel):
    record_type: str  # vaccine | checkup | deworming | flea_tick | other
    name: Optional[str] = None
    occurred_at: date

class PetInput(BaseModel):
    species: str  # dog | cat
    birthdate: Optional[date] = None
    weight_kg: Optional[float] = Field(default=None, ge=0)
    neutered: Optional[bool] = None
    breed: Optional[str] = None
    activity_level: Optional[str] = Field(default=None, description="low|medium|high")
    health_history: List[HealthEvent] = []

class ScoreOutput(BaseModel):
    score: float
    explanation: Dict[str, Any]

class Recommendation(BaseModel):
    kind: str  # nutrition | health | activity | marketplace
    title: str
    details: str

class RecoOutput(BaseModel):
    score: float
    recommendations: List[Recommendation]

def months_between(d1: date, d2: date) -> int:
    return (d2.year - d1.year) * 12 + (d2.month - d1.month)

IDEAL_WEIGHT = {
    "dog":  (5.0, 35.0),   # genérico; ajustar por porte/raça depois
    "cat":  (3.0, 6.0)
}

VACCINE_WINDOW_MONTHS = {
    "dog": 12,
    "cat": 12
}

@app.get("/health")
def health():
    return {"ok": True, "ts": datetime.utcnow().isoformat()}

def compute_kiara_score(pet: PetInput) -> ScoreOutput:
    base = 50.0
    reasons = {}

    if pet.birthdate:
        age_months = months_between(pet.birthdate, date.today())
        reasons["age_months"] = age_months
        if age_months < 12:
            base += 5
        elif age_months > 120:
            base -= 5

    if pet.weight_kg and pet.species in IDEAL_WEIGHT:
        lo, hi = IDEAL_WEIGHT[pet.species]
        if pet.weight_kg < lo * 0.9:
            base -= 10; reasons["underweight"] = True
        elif pet.weight_kg > hi * 1.1:
            base -= 10; reasons["overweight"] = True
        else:
            base += 5; reasons["weight_ok"] = True

    last_vaccine = None
    last_checkup = None
    for ev in pet.health_history:
        if ev.record_type == "vaccine":
            if (not last_vaccine) or (ev.occurred_at > last_vaccine):
                last_vaccine = ev.occurred_at
        if ev.record_type == "checkup":
            if (not last_checkup) or (ev.occurred_at > last_checkup):
                last_checkup = ev.occurred_at

    vw = VACCINE_WINDOW_MONTHS.get(pet.species, 12)
    today = date.today()

    if last_vaccine and months_between(last_vaccine, today) <= vw:
        base += 10; reasons["vaccines_up_to_date"] = True
    else:
        base -= 15; reasons["vaccines_due"] = True

    if last_checkup and months_between(last_checkup, today) <= 12:
        base += 5; reasons["checkup_recent"] = True
    else:
        base -= 5; reasons["checkup_due"] = True

    if pet.activity_level == "high":
        base += 5; reasons["activity"] = "high"
    elif pet.activity_level == "low":
        base -= 5; reasons["activity"] = "low"

    score = max(0.0, min(100.0, base))
    return ScoreOutput(score=score, explanation=reasons)

@app.post("/score", response_model=ScoreOutput)
def score(pet: PetInput):
    return compute_kiara_score(pet)

@app.post("/recommendations", response_model=RecoOutput)
def recommendations(pet: PetInput):
    s = compute_kiara_score(pet)
    recs: List[Recommendation] = []

    if s.explanation.get("vaccines_due"):
        recs.append(Recommendation(
            kind="health",
            title="Atualizar carteirinha de vacinas",
            details="Agende um check-up e verifique o calendário de vacinas para os próximos 12 meses."
        ))

    if s.explanation.get("overweight"):
        recs.append(Recommendation(
            kind="nutrition",
            title="Ajuste calórico + rações light",
            details="Considere ração light e divisão em 2–3 porções/dia; monitore peso semanalmente."
        ))

    if s.explanation.get("underweight"):
        recs.append(Recommendation(
            kind="nutrition",
            title="Plano de ganho saudável",
            details="Introduza alimento com maior densidade energética e avaliação veterinária."
        ))

    if s.explanation.get("checkup_due"):
        recs.append(Recommendation(
            kind="health",
            title="Check-up anual",
            details="Consulta preventiva ajuda a detectar problemas cedo e atualizar vermifugação/controle de pulgas."
        ))

    if s.explanation.get("activity") == "low":
        recs.append(Recommendation(
            kind="activity",
            title="Rotina de exercícios",
            details="Caminhadas curtas diárias (15–30min) e brinquedos interativos para estimular gasto energético."
        ))

    return RecoOutput(score=s.score, recommendations=recs)
