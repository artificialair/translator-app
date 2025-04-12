from google.cloud import speech

# Instantiates a client
client = speech.SpeechClient()
# Reads a file as bytes
with open("./en_espanol.wav", "rb") as f:
    audio_content = f.read()

audio = speech.RecognitionAudio(content=audio_content)

config = speech.RecognitionConfig(
    encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
    sample_rate_hertz=44100,
    language_code="es-US",
    audio_channel_count = 2,
)

response = client.recognize(config=config, audio=audio)

for i, result in enumerate(response.results):
    alternative = result.alternatives[0]
    print("-" * 20)
    print(f"First alternative of result {i}")
    print(f"Transcript: {alternative.transcript}")
