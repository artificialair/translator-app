from flask import request, Response
from . import routes
import json
import base64

import utils.speech_to_text as stt
import utils.translate as translator

@routes.route('/translate_audio', methods=['POST'])
async def translate_audio():
    if request.method == 'POST':
        content = request.get_json()
        audio_bytes = content.get('audio_bytes')
        src = content.get('src')
        dest = content.get('dest', 'en')

        if not audio_bytes:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: audio_bytes"}), status=403)
        elif not src:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: src"}), status=403)
        elif not dest:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: dest"}), status=403)
        else:
            decoded_audio = bytes(audio_bytes, encoding="utf-8")
            phrase = stt.speech_to_text(decoded_audio, src)
            translation = translator.translate(phrase, src=src, dest=dest)
            response = Response(json.dumps({"success": True, "content": await translation}), status=200)
        
        response.headers.set('Content-Type', 'application/json')
        return response
