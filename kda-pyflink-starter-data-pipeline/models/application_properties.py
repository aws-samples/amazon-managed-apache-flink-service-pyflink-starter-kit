from dataclasses import dataclass


@dataclass
class ApplicationProperties:
    input_stream: str
    input_stream_initpos: str
    input_stream_region: str
    db_host: str
    db_port: str
    db_name: str
    db_username: str
    db_password: str
