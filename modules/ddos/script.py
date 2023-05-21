import os
import time
import pprint
import re
from datetime import datetime
import sys


def compute_access_pattern(data_path):
    timestamp_format = "%d/%b/%Y:%H:%M:%S %z"
    timestamp_pattern = r'\[(.*?)\]'

    normal_access_sequences={}

    for file_path in os.listdir(data_path):
        ip_address = file_path
        file_path = f'{data_path}/{file_path}'


        f = open(file_path,'r')

        lines = f.readlines()

        t0=''
        t1=''
        access_sequence = []

        # time threshold
        delta_time = 30

        for line in lines:


            # first line
            if t0=='':
                t0=line

            t1 = line

            match = re.search(timestamp_pattern, t0)
            timestamp1=match.group(1)

            match = re.search(timestamp_pattern, t1)
            timestamp2=match.group(1)

            datetime1 = datetime.strptime(timestamp1, timestamp_format)
            datetime2 = datetime.strptime(timestamp2, timestamp_format)

            time_difference = datetime2 - datetime1


            # if we re inside the working sequence
            if time_difference.total_seconds() < delta_time:
                data = t1.split(' ')
                method = data[5]
                resource = data[6]
                answer = data[8]
                access_sequence.append(f'{timestamp2} {method} {resource} {answer}')

            else:
                log_parts = t0.split(' ')
                address= log_parts[0]
                if address in normal_access_sequences.keys():
                    if len(access_sequence) !=0:
                        normal_access_sequences[address].append(access_sequence)

                else:
                    normal_access_sequences[address]=[access_sequence]
                # change the root line
                access_sequence = []
                t0=t1
    return normal_access_sequences

if __name__=="__main__":

    print("about to detect some ddos 😎")
    print("🙀")
