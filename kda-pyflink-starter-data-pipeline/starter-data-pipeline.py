import logging
import os
import time
import boto3
from pyflink.common import Types
from pyflink.datastream import StreamExecutionEnvironment, CheckpointingMode, MapFunction, FlatMapFunction
from pyflink.datastream.state import MapStateDescriptor
from pyflink.table import StreamTableEnvironment

from utils.properties_loader import PropertiesLoader
from serialization.deserializer import Deserializer
from process.starter_key_process_func import StarterKeyedProcessFunction
from sink.sink_to_db_main import SinkToDB
from utils.db_credentials_loader import load_credentials
logging.basicConfig(level=logging.INFO)

__APPLICATION_PROPERTY_GRP_ID = "starter.data.pipeline.config"



def configure_app(table_env):
    is_local = True if os.environ.get("is_local") else False
    if is_local:
        CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))
        table_env.get_config().get_configuration().set_string(
            "pipeline.jars",
            f"file:///{CURRENT_DIR}/lib/kda-pyflink-starter-uber.jar"
        )
    return is_local

def load_application_properties(is_local):
    # get application properties
    application_properties_loader = PropertiesLoader(is_local)
    application_property_key = __APPLICATION_PROPERTY_GRP_ID
    application_properties = application_properties_loader.load_properties(application_property_key)
    return application_properties

def create_table(table_name, stream_name, region, stream_initpos):
    return """ CREATE TABLE {0} (
                data string,
                process_time AS PROCTIME()
              )
              WITH (
                'connector' = 'kinesis',
                'stream' = '{1}',
                'aws.region' = '{2}',
                'scan.stream.initpos' = '{3}',
                'format' = 'raw',
                'raw.charset' = 'UTF-8'
              ) """.format(
        table_name, stream_name, region, stream_initpos
    )

#flat map class and function for definitions
class FlatMapStockData(FlatMapFunction):
    def flat_map(self, value):
        print(value)
        yield value
        # for balance_data in value:
        #     telemetry_data = balance_data['data']
        #     for telemetry in telemetry_data:
        #         yield   telemetry.location.vehicle_id, telemetry.name, telemetry.value, telemetry.location.lap, telemetry.source,\


def main():
    env = StreamExecutionEnvironment.get_execution_environment()
    env.enable_checkpointing(420000, CheckpointingMode.AT_LEAST_ONCE)
    env.get_checkpoint_config().enable_unaligned_checkpoints()
    table_env = StreamTableEnvironment.create(env)
    is_local = configure_app(table_env)
    #load application properties
    application_properties = load_application_properties(is_local)

    print(application_properties)
    logging.debug(f"application_properties {application_properties}")

    deserializer = Deserializer()
    sink_to_db = SinkToDB()

    db_credentials = load_credentials(host=application_properties.db_host, port=application_properties.db_port, db_name=application_properties.db_name, db_username=application_properties.db_username, db_password=application_properties.db_password)
    print(db_credentials)
    #create a source table from Kinesis Data Stream
    input_table_name = "input_table"
    table_env.execute_sql(
        create_table(input_table_name, application_properties.input_stream, application_properties.input_stream_region, application_properties.input_stream_initpos)
    )

    table = table_env.sql_query("select * from {0}".format(input_table_name))
    data_stream = table_env.to_data_stream(table)
    # data_stream.print()

    json_data_stream = data_stream \
        .map(lambda data: deserializer.deserialize_to_json(data)) \
        .filter(lambda json_object: json_object is not None and json_object['ticker'] is not None) \
        .name("filter-valid-json")\
        .disable_chaining()

    # json_data_stream.print()

    #when the code is run on local machine comment the set_parallelism or make it (1)
    starter_data_stream = json_data_stream \
        .key_by(lambda json_object: f"{(json_object['ticker'])}" ) \
        .process(func=StarterKeyedProcessFunction()) \
        .name("starter-lap-process-func") \
        .disable_chaining()
    
    # starter_data_stream.print()

    starter_lap_ds = starter_data_stream \
        .map(lambda telemetrice_data_wrapper: (telemetrice_data_wrapper["ticker"], telemetrice_data_wrapper["event_time"], telemetrice_data_wrapper["price"], telemetrice_data_wrapper["server_process_time"], telemetrice_data_wrapper["key_process_time"]) ) .name("starter-map")
    # starter_lap_ds.print()
    sink_to_db.send_stock_data_sink(starter_lap_ds, db_credentials, "stock_data")

    logging.debug(f"Sink Activated: Saved telemetric data to postgress")        
    env.execute()
if __name__ == "__main__":


    main()
 
