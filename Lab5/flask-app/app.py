from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

def get_db():
    return psycopg2.connect(
        host=os.getenv('DB_HOST', 'db'),
        database=os.getenv('DB_NAME', 'myapp'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'secret')
    )

@app.route('/')
def hello():
    return '<h1>Flask + PostgreSQL w Docker Compose</h1>'

@app.route('/db')
def db_test():
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute('SELECT version();')
        version = cur.fetchone()[0]
        cur.close()
        conn.close()
        return jsonify({"status": "connected", "version": version})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/health')
def health():
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
