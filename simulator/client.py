import requests
import os
import time
from dotenv import load_dotenv

load_dotenv()

ENDPOINT = f'http://{os.getenv('BASE_IP')}'

def measure_latency(request_func):
    def func(*args, **kwargs):
        t1 = time.perf_counter_ns()
        request_func(*args, **kwargs)
        t2 = time.perf_counter_ns()
        latency = (t2 - t1) * 1e-6

        print(f'Response Latency: {latency:.2f}ms')

    return func

session = requests.Session()

@measure_latency
def send_request(text: str):
    payload = {
        'text': text
    }

    r = session.post(
        url=f'{ENDPOINT}/classify',
        json=payload
    )

    print(f'Response Code: {r.status_code}')
    print(f'Response Payload: {r.json()}')

    return r.json()

@measure_latency
def check_health():
    r = session.get(
        url=f'{ENDPOINT}/health'
    )

    print(f'Response Code: {r.status_code}')
    print(f'Response Payload: {r.json()}')

    return r.json()
