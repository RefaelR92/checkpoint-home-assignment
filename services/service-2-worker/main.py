import json
import os

import boto3

sqs = boto3.client("sqs")
s3 = boto3.client("s3")

QUEUE_URL = os.environ["SQS_QUEUE_URL"]
BUCKET = os.environ["S3_BUCKET"]
PREFIX = os.environ.get("S3_PREFIX", "messages/")

while True:
    resp = sqs.receive_message(
        QueueUrl=QUEUE_URL,
        MaxNumberOfMessages=10,
        WaitTimeSeconds=20,  # LONG POLLING
        VisibilityTimeout=60,
    )

    messages = resp.get("Messages", [])
    if not messages:
        continue  # no sleep needed — long poll handles it

    for msg in messages:
        body = json.loads(msg["Body"])

        key = f"{PREFIX}{msg['MessageId']}.json"
        s3.put_object(Bucket=BUCKET, Key=key, Body=json.dumps(body))

        sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=msg["ReceiptHandle"])
