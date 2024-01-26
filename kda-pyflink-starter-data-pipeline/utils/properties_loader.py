import json
import os

from models.application_properties import ApplicationProperties

class PropertiesLoader:
    def __init__(self, is_local):
        self.is_local = is_local
        self.application_properties_path = "./conf/application_properties.json" if is_local else "/etc/flink/application_properties.json"
        self.properties = self.load_application_properties()

    def load_application_properties(self):

        if os.path.isfile(self.application_properties_path):
            with open(self.application_properties_path, "r") as file:
                contents = file.read()
                properties = json.loads(contents)
                return properties
        else:
            err_msg = 'A file at "{}" was not found'.format(self.application_properties_path)
            raise Exception(err_msg)
        
    def get_property_map(self, property_group_id):
        for prop in self.properties:
            if prop["PropertyGroupId"] == property_group_id:
                return prop["PropertyMap"]
            
    def load_properties(self, application_property_key):
        input_stream_key = "input.stream.name"
        input_region_key = "aws.region"
        input_starting_position_key = "flink.stream.initpos"
        db_host_key = "db.host"
        db_port_key = "db.port"
        db_name_key = "db.name"
        db_username_key = "db.username"
        db_password_key = "db.password"
        metadata_bucket_name_key = "metadata.bucket.name"
        track_data_path_key = "track.data.path"
        track_file_name_key = "track.file.name"
        tel_data_message_key = "tel.data.message.buffer"
        pos_data_message_key = "pos.data.message.buffer"
        application_properties_map = self.get_property_map(application_property_key)
        input_stream = application_properties_map[input_stream_key]
        input_region = application_properties_map[input_region_key]
        stream_initpos = application_properties_map[input_starting_position_key]
        db_host = application_properties_map[db_host_key]
        db_port = application_properties_map[db_port_key]
        db_name = application_properties_map[db_name_key]
        db_username = application_properties_map[db_username_key]
        db_password = application_properties_map[db_password_key]
        return ApplicationProperties(input_stream=input_stream, input_stream_region=input_region, input_stream_initpos=stream_initpos, db_host=db_host, db_port=db_port,db_name=db_name, 
                                     db_username=db_username,db_password=db_password)