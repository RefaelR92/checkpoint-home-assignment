from datetime import datetime

from pydantic import BaseModel, Field, field_validator


class EmailData(BaseModel):
    email_subject: str
    email_sender: str
    email_timestream: str = Field(..., description="Unix timestamp string")
    email_content: str

    @field_validator("email_timestream")
    @classmethod
    def validate_timestamp(cls, v: str):
        try:
            # Check if it can be converted to an int and then a valid date
            datetime.fromtimestamp(int(v))
            return v
        except (ValueError, TypeError):
            raise ValueError(
                "Invalid timestamp format; must be a valid Unix timestream."
            )


class RequestBody(BaseModel):
    data: EmailData
    token: str
