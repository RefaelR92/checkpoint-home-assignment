import json
import boto3
from settings import AWS_REGION
from datetime import datetime

sqs = boto3.client("sqs", region_name=AWS_REGION)
s3  = boto3.client("s3", region_name=AWS_REGION)

def receive_messages(queue_url, max_messages, wait_time):
    return sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=max_messages,
        WaitTimeSeconds=wait_time
    )


def upload_to_s3(bucket, prefix, message_id, body):
    key = f"{prefix}{message_id}.json"

    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=json.dumps(body),
        ContentType="application/json"
    )

    return key


def delete_message(queue_url, receipt_handle):
    sqs.delete_message(
        QueueUrl=queue_url,
        ReceiptHandle=receipt_handle
    )
