from datetime import datetime
from flask import Flask, jsonify, request
from pydantic import ValidationError
from models import RequestBody

from aws import get_expected_token, send_to_sqs
from settings import SQS_QUEUE_URL

app = Flask(__name__)


@app.route("/publish", methods=["POST"])
def publish():
   # Parse and Validate Schema using Pydantic
    try:
        raw_json = request.get_json(force=True)
        # This checks field presence, types, and the custom timestamp logic
        validated_body = RequestBody(**raw_json)
    except ValidationError as e:
        return jsonify({"error": "Validation failed", "details": e.errors()}), 400
    except Exception:
        return jsonify({"error": "Malformed JSON"}), 400

    # We compare the validated token against SSM
    if validated_body.token != get_expected_token():
        return jsonify({"error": "Invalid token"}), 401

    # 3. Success: Send the nested data to SQS
    # Use .dict() or .model_dump() to convert the Pydantic object back to a dict
    send_to_sqs(SQS_QUEUE_URL, validated_body.data.model_dump())

    return jsonify({"status": "ok"}), 200


@app.route("/health", methods=["GET"])
def health():
    return "ok", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
