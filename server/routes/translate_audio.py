from flask import request, Response
from . import routes
import json
import base64

import utils.speech_to_text as stt
import utils.translate as translator

@routes.route('/translate_audio', methods=['GET'])
async def translate_audio():
    if request.method == 'GET':
        audio_bytes = request.args.get('audio_bytes')
        src = request.args.get('src')
        dest = request.args.get('dest', 'en')
        if not audio_bytes:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: audio_bytes"}), status=403)
        elif not src:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: src"}), status=403)
        elif not dest:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: dest"}), status=403)
        else:
            decoded_audio = base64.decode(audio_bytes)
            phrase = stt.speech_to_text(decoded_audio)
            translation = translator.translate(phrase, src=src, dest=dest)
            response = Response(json.dumps({"success": True, "content": (await translation).text}), status=200)
        
        response.headers.set('Content-Type', 'application/json')
        return response
