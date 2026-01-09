import json

from aws import delete_message, receive_messages, upload_to_s3
from settings import MAX_MESSAGES, S3_BUCKET, S3_PREFIX, SQS_QUEUE_URL, WAIT_TIME

print("Worker started")

while True:
    response = receive_messages(
        queue_url=SQS_QUEUE_URL,
        max_messages=MAX_MESSAGES,
        wait_time=WAIT_TIME,
    )

    messages = response.get("Messages", [])

    if not messages:
        continue  # long polling already waited

    for msg in messages:
        try:
            body = json.loads(msg["Body"])
            message_id = msg["MessageId"]

            key = upload_to_s3(
                bucket=S3_BUCKET,
                prefix=S3_PREFIX,
                message_id=message_id,
                body=body,
            )

            delete_message(
                queue_url=SQS_QUEUE_URL,
                receipt_handle=msg["ReceiptHandle"],
            )

            print(f"Processed message {message_id} → s3://{S3_BUCKET}/{key}")

        except Exception as e:
            # Do NOT delete message on failure
            print(f"Error processing message: {e}")
