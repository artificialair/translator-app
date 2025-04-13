import base64
import requests
import json

with open("./en_espanol.wav", "rb") as audio_file:
    audio_content = audio_file.read()

headers = {
    "Content-Type": "application/json"
}

body = {
    "audio_bytes" : str(audio_file),
    "src" : "es",
    "dest": "en"
}

req = requests.post("http://localhost:5000/translate_audio", headers=headers, data=json.dumps(body))
print(req.json())
