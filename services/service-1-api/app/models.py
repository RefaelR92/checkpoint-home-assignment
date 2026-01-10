from typing import Any, Dict

from pydantic import BaseModel, Field


class Payload(BaseModel):
    email_subject: str
    email_sender: str
    email_timestream: int = Field(..., description="Unix timestream")
    email_content: str


class RequestBody(BaseModel):
    data: Payload
    token: str


test = RequestBody()
