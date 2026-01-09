import json
import boto3
from settings import AWS_REGION, TOKEN_SSM_PARAM

_ssm = boto3.client("ssm", region_name=AWS_REGION)
_sqs = boto3.client("sqs", region_name=AWS_REGION)

_cached_token = None


def get_expected_token():
    global _cached_token
    if _cached_token is None:
        resp = _ssm.get_parameter(Name=TOKEN_SSM_PARAM, WithDecryption=True)
        _cached_token = resp["Parameter"]["Value"]
    return _cached_token


def send_to_sqs(queue_url, message):
    _sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps(message))
