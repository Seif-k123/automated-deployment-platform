from flask import Flask
from prometheus_flask_exporter import PrometheusExporter

app = Flask(__name__)
PrometheusExporter(app)

@app.route("/")
def home():
    return "🚀 DevOps Platform - Flask App Deployed via Terraform + Ansible"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
