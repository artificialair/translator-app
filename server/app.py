from flask import Flask
from routes import *

app = Flask(__name__)
app.register_blueprint(routes)

@app.route('/')
def home():
    return "<p>hi! you shouldn't be here. get out. leave.</p>"

if __name__ == "__main__":
    app.run()