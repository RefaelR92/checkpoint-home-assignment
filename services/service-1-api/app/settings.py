import os

AWS_REGION = os.getenv("AWS_REGION", "us-east-2")
SQS_QUEUE_URL = os.environ["SQS_QUEUE_URL"]
TOKEN_SSM_PARAM = os.environ["TOKEN_SSM_PARAM"]
