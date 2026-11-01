import requests
import os
from dotenv import load_dotenv

load_dotenv()

ENDPOINT = f'http://{os.getenv('BASE_IP')}:8000/classify'

def send_request(text: str):
    payload = {
        'text': text
    }

    r = requests.post(
        url=ENDPOINT,
        json=payload
    )
    print(r)
    return r.json()