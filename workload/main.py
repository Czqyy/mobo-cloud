import json
from pydantic import BaseModel
from fastapi import FastAPI
from contextlib import asynccontextmanager
from transformers import pipeline


models = {}

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Load model
    models['bert'] = pipeline(
        task="text-classification",
        model="distilbert-base-uncased-finetuned-sst-2-english",
        device=1
    )
    yield

    # Clean up
    models.clear()

class InferenceRequest(BaseModel):
    text: str

app = FastAPI(lifespan=lifespan)

@app.post("/classify")
def classify(request: InferenceRequest):
    model = models['bert']
    result = model(request.text)[0]
    return result
