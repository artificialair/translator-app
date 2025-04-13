from google.cloud import speech

async def speech_to_text(audio_file):
    client = speech.SpeechClient()
    with open(audio_file, "rb") as f:
        audio_content = f.read()
    
    audio = speech.RecognitionAudio(content=audio_content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=44100,
        language_code="es-US",
        audio_channel_count = 2,
    )

    response = client.recognize(config=config, audio=audio)
    return await(response).results[0]
