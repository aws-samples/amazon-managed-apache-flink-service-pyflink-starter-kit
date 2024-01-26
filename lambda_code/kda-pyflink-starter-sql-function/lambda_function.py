import json
import psycopg2
import os

def lambda_handler(event, context):
    # TODO implement
    host = os.environ.get('db_host', 'localhost')
    user = os.environ.get('db_username', 'admin')
    password = os.environ.get('db_password', 'localhost')
    port = os.environ.get('db_port', 'localhost')
    database = os.environ.get('db_database', 'localhost')
    ################################################################
    # code to connect to db                                        #
    ################################################################
    conn = psycopg2.connect(database=database,
                        host=host,
                        user=user,
                        password=password,
                        port=port)

    print(f"Connecting to {conn}")
    ################################################################
    # code to drop stock_data table if  available                  #
    ################################################################
    # cursor = conn.cursor()
    # cursor.execute('drop table IF EXISTS stock_data')
    # conn.commit()

    ################################################################
    # code to create a new stock_data table if not available       #
    ################################################################
    cursor = conn.cursor()
    
    table_name = 'stock_data'
    stock_data_create_sql = f""" create table IF NOT EXISTS {table_name} 
                                (
                            	symbol text ,
                                event_time text ,
                                price text ,
                                server_process_time text, 
                                key_process_time text
                                )
                                """
    cursor.execute(stock_data_create_sql)
    
    cursor.close()
    conn.commit()
    
    cursor = conn.cursor()
    sql = """SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'public'"""
    
    cursor.execute(sql)
    for table in cursor.fetchall():
        print(table)

    ################################################################
    # code to show the count of stock data                         #
    ################################################################
    cursor = conn.cursor()
    cursor.execute('select * from stock_data')
    rows = cursor.fetchall()
    print('ResultCount = %d' % len(rows))


    return {
        'statusCode': 200,
        'body': json.dumps('Kda PyFlink Testing Module!')
    }
