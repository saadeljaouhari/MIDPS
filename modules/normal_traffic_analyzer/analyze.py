import os
import sys
import pprint
import re
import json
import threading
from datetime import datetime

def process_access_seq_file(file_path):
    result=[]
    file = open(file_path, "r")
    for line in file.readlines():
        line = line.rstrip('\n')
        seq = line.split(',')
        result.append(seq)
    return result

def append_data_in_array(line,timestamp,arr):

        data = line.split(' ')
        method = data[5]
        resource = data[6]
        answer = data[8]
        # if the line is regular
        if len(data)>=11:
            referrer = data[10]
        else:
            referrer = '"-"'
        arr.append("{} {} {} {} {}".format(timestamp,method, resource, answer,referrer))

        return arr


def compute_access_pattern(data_path,delta_time):

    timestamp_format = "%d/%b/%Y:%H:%M:%S %z"
    timestamp_pattern = r'\[(.*?)\]'

    normal_access_sequences={}

    delta_time=float(delta_time)

    for file_path in os.listdir(data_path):

        if file_path == 'ip_list':
            continue
        ip_address = file_path
        file_path = '{}/{}'.format(data_path, file_path)

        f = open(file_path,'r')
        lines = f.readlines()

        t0=''
        t1=''
        access_sequence = []


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
            if time_difference.total_seconds() <= delta_time:

                access_sequence = append_data_in_array(t1,timestamp2,access_sequence)

            else:
                log_parts = t0.split(' ')
                address= log_parts[0]
                if address in normal_access_sequences.keys():
                    if len(access_sequence) !=0:
                        normal_access_sequences[address].append(access_sequence)

                else:
                    normal_access_sequences[address]=[access_sequence]
                # reset the timer
                #delta_time=0
                # reinitialise the access sequence and append the first line
                access_sequence = []
                access_sequence = append_data_in_array(t1,timestamp2,access_sequence)
            # change the root line
            t0=t1

        # add the last processed sequence
        log_parts = t0.split(' ')
        address= log_parts[0]
        if address in normal_access_sequences.keys():
            if len(access_sequence) !=0:
                normal_access_sequences[address].append(access_sequence)

        else:
            normal_access_sequences[address]=[access_sequence]

    return normal_access_sequences

def strip_timestamp_referrer_from_line(line):
    return line.split(' ')[2:-1]

def delete_timestamp_referrer_from_sequence(seq):
    result=[]
    for line in seq:
        line = strip_timestamp_referrer_from_line(line)
        result.append(line)
    return result

def analyze_request_sequence(address,access_sequence,computed_norm_access_seq):
    matched_sequence = False
    stripped_access_sequence = delete_timestamp_referrer_from_sequence(access_sequence)

    for sequence in computed_norm_access_seq:
        sequence = delete_timestamp_referrer_from_sequence(sequence)
        if sorted(stripped_access_sequence) == sorted(sequence):
            matched_sequence = True
            break
    list_str = ','.join(access_sequence)
    if not matched_sequence:
        # send the sequence to further analysis
        frame_name=log_folder_path.split('/')[:-1]
        frame_folder_path='{}/{}'.format(suspect_traffic_folder_path,frame_name)
        if not os.path.exists(frame_folder_path):
            os.makedirs(frame_folder_path)
        sequence_file_path='{}/{}'.format(frame_folder_path,address)
        with open(sequence_file_path,"a+") as f:
            f.write(list_str)
            f.write("\n")
    else:
        print("{} made a normal access. \n Access seq: {} ".format(address, list_str ))


if __name__=="__main__":

    command=sys.argv[1]

    log_folder_path=sys.argv[2]

    delta_time=sys.argv[3]

    suspect_traffic_folder_path="/tmp/logs/suspect_traffic"

    normal_access_sequences = compute_access_pattern(log_folder_path,delta_time)
    # switch on the commands
    # export the computed access patterns
    if command == "export":
        #pprint.pprint(normal_access_sequence)
        output_path = sys.argv[4]
        if output_path is not None:
            with open(output_path,"w+") as file:
                for address in normal_access_sequences.keys():
                    for access_sequence in normal_access_sequences[address]:
                        file.write(','.join(access_sequence))
                        file.write("\n")
        else:
            print("No output path specified!")

    if command == "analyze":
        normal_access_seq_file = sys.argv[4]
        computed_norm_access_seq = process_access_seq_file(normal_access_seq_file)

        for address in normal_access_sequences.keys():
            for sequence in normal_access_sequences[address]:
                th = threading.Thread(target=analyze_request_sequence, args=(address,sequence,computed_norm_access_seq))
                th.start()
