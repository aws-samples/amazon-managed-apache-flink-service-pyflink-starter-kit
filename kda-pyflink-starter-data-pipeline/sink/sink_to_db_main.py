import time
import logging

from pyflink.datastream import FlatMapFunction
from pyflink.common import Types, Row
from pyflink.datastream import MapFunction
from pyflink.datastream.connectors import JdbcSink, JdbcConnectionOptions, JdbcExecutionOptions



class FlatMapVehicleData(FlatMapFunction):
    def flat_map(self, value):
        for balance_data in value:
            yield balance_data


class SinkToDB:
    @staticmethod
    def send_stock_data_sink(stock_lap_stream, db_credentials, table_name):
        
        type_info = Types.ROW_NAMED(
            ['symbol','event_time','price','server_process_time','key_process_time'],
            [Types.STRING(),Types.STRING(),Types.STRING(),Types.STRING(),Types.STRING()])

        stock_data_sql = f""" insert into {table_name} 
                                    (symbol, event_time,price,server_process_time,key_process_time)
                                    values(?,?,?,?,?)
                                 """
        table_name_1 = 'stock_data_1'
        stock_data_create_sql = f""" create table IF NOT EXISTS {table_name_1} 
                                    (symbol text,event_time text)
                                 """
        # JdbcSink.sink(stock_data_create_sql,
        #                           JdbcConnectionOptions.JdbcConnectionOptionsBuilder()
        #                           .with_url(db_credentials.db_url)
        #                           .with_driver_name('org.postgresql.Driver')
        #                           .with_user_name(db_credentials.db_username)
        #                           .with_password(db_credentials.db_password)
        #                           .build(), JdbcExecutionOptions.builder() \
        #                           .with_batch_interval_ms(1000) \
        #                           .with_batch_size(2000) \
        #                           .with_max_retries(5) \
        #                           .build())
        
        jdbc_sink = JdbcSink.sink(stock_data_sql,
                                  type_info,
                                  JdbcConnectionOptions.JdbcConnectionOptionsBuilder()
                                  .with_url(db_credentials.db_url)
                                  .with_driver_name('org.postgresql.Driver')
                                  .with_user_name(db_credentials.db_username)
                                  .with_password(db_credentials.db_password)
                                  .build(), JdbcExecutionOptions.builder() \
                                  .with_batch_interval_ms(1000) \
                                  .with_batch_size(2000) \
                                  .with_max_retries(5) \
                                  .build())

        # to view the data before pushing to db
        # stock_lap_stream.map(
        #     lambda element: Row(str(element[0]), str(element[1]), str(element[2]), str(element[3]), str(element[4]))
        #     , output_type=type_info).print()
        stock_lap_stream.map(
            lambda element: Row(str(element[0]), str(element[1]), str(element[2]), str(element[3]), str(element[4]))
            , output_type=type_info).add_sink(jdbc_sink)

        logging.info(f"Sink Activated: Save completed")

   




