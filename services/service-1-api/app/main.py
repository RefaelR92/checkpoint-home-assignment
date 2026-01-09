from flask import Flask, request, jsonify
from datetime import datetime

from settings import SQS_QUEUE_URL
from aws import get_expected_token, send_to_sqs

app = Flask(__name__)


@app.route("/publish", methods=["POST"])
def publish():
    body = request.get_json(force=True)

    # Token validation
    if body.get("token") != get_expected_token():
        return jsonify({"error": "Invalid token"}), 401

    data = body.get("data", {})

    # Timestamp validation
    try:
        datetime.fromtimestamp(int(data.get("email_timestamp")))
    except Exception:
        return jsonify({"error": "Invalid email_timestamp"}), 400

    send_to_sqs(SQS_QUEUE_URL, data)

    return jsonify({"status": "ok"}), 200


@app.route("/health", methods=["GET"])
def health():
    return "ok", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
