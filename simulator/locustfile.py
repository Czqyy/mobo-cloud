import os
from locust import HttpUser, task, poisson
from dotenv import load_dotenv

load_dotenv()

ENDPOINT = f'http://{os.getenv('BASE_IP')}'

class RequestSimulator(HttpUser):
  host = ENDPOINT
  wait_time = poisson(1)

  @task
  def send_inference(self):
    payload = {
      'text': 'hi'
    }
    self.client.post('/classify', json=payload)
    