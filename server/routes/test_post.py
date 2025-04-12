from flask import request, Response
from . import routes
import json

@routes.route('/test_post', methods=['POST'])
def test_post():
    if request.method == 'POST':
        content = request.get_json()
        print(f"Request recieved! Content: {content}")
        test_bool = content.get('hi', False)
        if test_bool:
            response = Response(json.dumps({"content": "omg hi", "number": 17}), status=200)
        else:
            response = Response(json.dumps({"content": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "number": 1}), status=200)
        response.headers.set('Content-Type', 'application/json')
        return response
