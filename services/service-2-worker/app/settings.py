import os

def require_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"Missing required env var: {name}")
    return value

SQS_QUEUE_URL = require_env("SQS_QUEUE_URL")
S3_BUCKET     = require_env("S3_BUCKET")

AWS_REGION = os.getenv("AWS_REGION", "us-east-2")
S3_PREFIX     = os.getenv("S3_PREFIX", "messages/")
MAX_MESSAGES  = int(os.getenv("MAX_MESSAGES", "10"))
WAIT_TIME     = int(os.getenv("WAIT_TIME", "20"))
