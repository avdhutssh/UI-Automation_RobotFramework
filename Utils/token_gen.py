import requests
import os

"""Generates the bearer token required for onboarding and buildingX APIs"""
client_id = os.environ.get("CLIENT_ID", "")
client_secret = os.environ.get("CLIENT_SECRET", "")
audience = ""
token_url = ""

def get_access_token():
    request_body = {
        "client_id": client_id,
        "client_secret": client_secret,
        "audience": audience,
        "grant_type": "client_credentials"
    }
    response = requests.post(token_url, json=request_body)
    if response.status_code == 200:
        response_data = response.json()
        access_token = response_data.get("access_token")
        return access_token
    else:
        response.raise_for_status()