from models.db_credentials import DbCredentials

def load_credentials(host, port, db_name, db_username, db_password):
    # session = boto3.session.Session()
    # client = session.client(
    #     service_name='secretsmanager',
    #     region_name=region
    # )
    # try:
    #     get_secret_value_response = client.get_secret_value(
    #         SecretId=db_secret
    #     )
    # except ClientError as e:
    #     raise e

    # secret = get_secret_value_response['SecretString']
    # json_object = json.loads(secret)
    db_url = f"jdbc:postgresql://{host}:{port}/{db_name}"
    return DbCredentials(db_url=db_url, db_username=db_username, db_password=db_password)