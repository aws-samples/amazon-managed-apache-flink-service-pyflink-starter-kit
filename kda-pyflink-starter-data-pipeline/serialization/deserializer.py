import json
import logging


class Deserializer:
    @staticmethod
    def deserialize_to_json(data):
        try:
            json_object = json.loads(data[0])
            json_object['server_process_time'] = data[1].to_epoch_milli()
            # print(f"json_object - {json_object} & type is {type(json_object)}")
            # logging.info(f"json_object - {json_object} & type is {type(json_object)}")
            return json_object
        except Exception as e:
            logging.error(f"Error in parsing the data to json, error {e} & data {data}")
            return None