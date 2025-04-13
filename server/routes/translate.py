from flask import request, Response
from . import routes
import json

import utils.translate as translator

@routes.route('/translate', methods=['GET'])
async def translate():
    if request.method == 'GET':
        phrase = request.args.get('string')
        src = request.args.get('src')
        dest = request.args.get('dest', 'en')
        if not phrase:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: string"}), status=403)
        elif not src:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: src"}), status=403)
        elif not dest:
            response = Response(json.dumps({"success": False, "reason": "Missing one or more args: dest"}), status=403)
        else:
            translation = translator.translate(phrase=phrase, src=src, dest=dest)
            response = Response(json.dumps({"success": True, "content": await translation}), status=200)
        
        response.headers.set('Content-Type', 'application/json')
        return response
