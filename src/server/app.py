import os

import mlflow.pyfunc
import pandas as pd
import yaml
from fastapi import FastAPI
from pydantic import BaseModel

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
# model = joblib.load(model_path)

# Suppose your model was logged in a run with run_id
run_id = config.get("model").get("id")
artifact_path = "model"  # The artifact path you specified during logging

# Construct the model URI
model_uri = f"runs:/{run_id}/{artifact_path}"
mlflow.set_tracking_uri(config.get('mlflow').get('tracking_url'))


@app.get("/")
async def root():
    return {"health_check": "201"}


@app.post("/predict")
async def predict(input_data: InputData):
    model = mlflow.pyfunc.load_model(model_uri)
    df = pd.DataFrame([input_data.model_dump().values()],
                      columns=input_data.model_dump().keys())

    df['Age'] = df['Age'].astype('float64')
    pred = model.predict(df)
    return {"predicted_class": int(pred[0])}
