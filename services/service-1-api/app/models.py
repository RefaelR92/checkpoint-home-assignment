from pydantic import BaseModel, Field
from typing import Dict, Any


class Payload(BaseModel):
    email_subject: str
    email_sender: str
    email_timestamp: int = Field(..., description="Unix timestamp")
    email_content: str


class RequestBody(BaseModel):
    data: Payload
    token: str
