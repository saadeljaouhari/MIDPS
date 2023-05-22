import os
import time
import pprint
import re
from datetime import datetime
import sys


tmp_folder_path="/tmp/out"

def compute_access_sequences(file_path):
    timestamp_format = "%d/%b/%Y:%H:%M:%S %z"
    timestamp_pattern = r'\[(.*?)\]'
    access_sequences={}
    t0=''
    t1=''
    seq_index=0
    access_sequence = []

    # time threshold
    delta_time = 10

    f = open(file_path,'r')

    lines = f.readlines()

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
            access_sequence.append("{} {} {} {}".format(timestamp2, method, resource, answer))

        else:
            log_parts = t0.split(' ')
            address= log_parts[0]
            if address in access_sequences.keys():
                if len(access_sequence) !=0:
                    access_sequences[address].append(access_sequence)

            else:
                access_sequences[address]=access_sequence
            # change the root line
            access_sequence = []
            t0=t1

    #adding the rest
    log_parts = t0.split(' ')
    address= log_parts[0]
    if address in access_sequences.keys():
        if len(access_sequence) !=0:
            access_sequences[address].append(access_sequence)

    else:
        access_sequences[address]=access_sequence
    #access_sequences[seq_index]=access_sequence
    return access_sequences


def detect_dos(access_sequence):
    # frequency ratio based on snort rules
    if len(access_sequence) >= 500:
        return 1
    else:
        return 0



if __name__=="__main__":

    for file_name in os.listdir(tmp_folder_path):
        file_path = '{}/{}'.format(tmp_folder_path, file_name)
        access_sequences=compute_access_sequences(file_path)
        for key in access_sequences.keys():
            verdict = detect_dos(access_sequences[key])
            if verdict == 0:
                print("Normal usage")
            else:
                print('{} - Likely DDOS'.format(key))
