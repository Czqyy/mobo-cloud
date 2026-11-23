import os
from locust import HttpUser, LoadTestShape, task, poisson
from dotenv import load_dotenv
import math
import random
import json

load_dotenv()

random.seed(42)

ENDPOINT = f'http://{os.getenv('BASE_IP')}'

with open("corpus.jsonl", "r", encoding="utf-8") as f:
   PAYLOADS = [json.loads(line) for line in f if line.strip()]

class RequestSimulator(HttpUser):
  host = ENDPOINT
  wait_time = poisson(3)

  @task
  def send_inference(self):
    payload = random.choice(PAYLOADS)
    self.client.post('/classify', json=payload)

class StageLoadShape(LoadTestShape):
  stages = [
     {"duration": 120, "users": 10, "spawn_rate": 5},
     {"duration": 480, "users": 300, "spawn_rate": 50},
     {"duration": 1200, "users": 10, "spawn_rate": 10}
  ]

  def tick(self):
    run_time = self.get_run_time()

    for stage in self.stages:
      if run_time < stage["duration"]:
        return (stage["users"], stage["spawn_rate"])

    return None