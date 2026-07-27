"""
Prosta aplikacja webowa (Flask) wykorzystywana jako obiekt badawczy
do demonstracji skanowania bezpieczenstwa obrazow Docker.

Aplikacja celowo jest minimalna - jej celem nie jest funkcjonalnosc,
lecz dostarczenie realnego artefaktu (obrazu kontenera) zawierajacego
zaleznosci systemowe i aplikacyjne, ktore skanery (Trivy, Grype,
Docker Scout) moga przeanalizowac pod katem podatnosci CVE.
"""
from flask import Flask, jsonify
import platform

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify(
        {
            "message": "Docker Security Pipeline - aplikacja demonstracyjna",
            "status": "ok",
        }
    )


@app.route("/health")
def health():
    """Endpoint wykorzystywany przez Kubernetes do testow dostepnosci (liveness/readiness)."""
    return jsonify({"status": "healthy"}), 200


@app.route("/info")
def info():
    return jsonify(
        {
            "python_version": platform.python_version(),
            "system": platform.system(),
        }
    )


if __name__ == "__main__":
    # 0.0.0.0 - nasluchiwanie na wszystkich interfejsach (wymagane w kontenerze)
    app.run(host="0.0.0.0", port=5000)
