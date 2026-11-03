from flask import Flask
import requests
import os

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = os.uname().nodename
    return f"<h1>Witaj z kontenera {hostname}!</h1><p>Flask działa w Dockerze.</p>"

@app.route('/health')
def health():
    return {"status": "ok"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
