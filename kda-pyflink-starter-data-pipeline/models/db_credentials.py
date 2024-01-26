from dataclasses import dataclass


@dataclass
class DbCredentials:
    db_url: str
    db_username: str
    db_password: str
