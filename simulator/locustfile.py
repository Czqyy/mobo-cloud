import os
from locust import HttpUser, LoadTestShape, task, poisson
from dotenv import load_dotenv
import math

load_dotenv()

ENDPOINT = f'http://{os.getenv('BASE_IP')}'

class RequestSimulator(HttpUser):
  host = ENDPOINT
  wait_time = poisson(3)

  @task
  def send_inference(self):
    payload = {
      'text': 'hi'
    }
    self.client.post('/classify', json=payload)

class StepLoadShape(LoadTestShape):
    """
    A step load shape

    Keyword arguments:

        step_time -- Time between steps
        step_load -- User increase amount at each step
        spawn_rate -- Users to stop/start per second at every step
        time_limit -- Time limit in seconds

    """

    step_time = 20
    step_load = 10
    spawn_rate = 10
    time_limit = 180

    def tick(self):
        run_time = self.get_run_time()

        if run_time > self.time_limit:
            return None

        current_step = math.floor(run_time / self.step_time) + 1
        return (current_step * self.step_load, self.spawn_rate)