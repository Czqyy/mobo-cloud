import requests

BASE = 'http://0.0.0.0:8000/classify'

def send_request(text: str):
    payload = {
        'text': text
    }

    r = requests.post(
        url=BASE,
        json=payload
    )
    return r.json()