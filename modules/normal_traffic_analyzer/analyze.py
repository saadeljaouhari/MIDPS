import os
import sys
import pprint
import re
import json
from datetime import datetime

def append_data_in_array(line,timestamp,arr):

        data = line.split(' ')
        method = data[5]
        resource = data[6]
        answer = data[8]
        # if the line is regular
        if len(data)>=11:
            referrer = data[10]
        arr.append("{} {} {} {} {}".format(timestamp, method, resource, answer,referrer))

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

def analyze_request_sequence(address,access_sequence):
    print(address)
    print(access_sequence)


if __name__=="__main__":

    command=sys.argv[1]

    log_folder_path=sys.argv[2]

    delta_time=sys.argv[3]

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
            print(normal_access_sequences)
        else:
            print("No output path specified!")

    if command == "analyze":
        for address in normal_access_sequences.keys():
            analyze_request_sequence(address,normal_access_sequences[address])
