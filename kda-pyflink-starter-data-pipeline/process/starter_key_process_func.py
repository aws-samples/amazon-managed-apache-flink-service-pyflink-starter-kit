import logging
import time
import os
import sys
import json

from pyflink.datastream.functions import KeyedProcessFunction, RuntimeContext
from pyflink.datastream.state import ValueStateDescriptor
from pyflink.common import Types
import pandas as pd
import numpy as np

import boto3
import datetime




class StarterKeyedProcessFunction(KeyedProcessFunction):
    def __init__(self):
        print('initializing')

    
    def process_element(self, json_object, ctx: 'KeyedProcessFunction.Context'):
        curr_key = json_object['ticker']
        print(f'Key --> {curr_key} -:- Current Key --> {ctx.get_current_key()}')

        # print(f'Main JSON --- {json_object}')
        json_object['key_process_time'] = 'key_process'
        yield json_object
