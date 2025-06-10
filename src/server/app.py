import os

import yaml
from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib

app = FastAPI()

script_dir = os.path.dirname(os.path.realpath(__file__))
config_path = os.path.join(script_dir, 'config.yml')


class InputData(BaseModel):
    Gender: str
    Age: int
    HasDrivingLicense: int
    RegionID: float
    Switch: int
    PastAccident: str
    AnnualPremium: float


with open('./config.yml', 'r') as file:
    config = yaml.safe_load(file)

model_path = os.path.join(script_dir, 'models', config.get("model").get("full_file_name"))
model = joblib.load(model_path)


@app.get("/")
async def root():
    return {"health_check": "200"}


@app.post("/predict")
async def predict(input_data: InputData):
    df = pd.DataFrame([input_data.model_dump().values()],
                      columns=input_data.model_dump().keys())
    pred = model.predict(df)
    return {"predicted_class": int(pred[0])}
