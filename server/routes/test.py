from flask import render_template
from . import routes

@routes.route('/test')
def test():
    return "<h1>hiiiiiiiiiii</h1>"