import os
import sys
import pprint
import re
import json
import threading
from datetime import datetime


def extract_time_diff(t0,t1):

    timestamp_format = "%d/%b/%Y:%H:%M:%S %z"

    timestamp_info_1=t0.split(' ')[:2]
    timestamp1=' '.join(timestamp_info_1)


    timestamp_info_2=t1.split(' ')[:2]
    timestamp2 = ' '.join(timestamp_info_2)

    datetime1 = datetime.strptime(timestamp1, timestamp_format)
    datetime2 = datetime.strptime(timestamp2, timestamp_format)

    time_difference = datetime2 - datetime1

    return time_difference


def compute_request_rate(file_path,delta_time):


    request_rate= {}

    delta_time=float(delta_time)

    f = open(file_path,'r')
    lines = f.readlines()

    request_index=0
    count=0
    first_line=lines[0]
    t0=''
    t1=''

    for line in lines:

        # first line
        if t0=='':
            t0=line

        t1 = line

        time_difference=extract_time_diff(t0,t1)

        # if we re inside the working sequence
        if time_difference.total_seconds() <= delta_time:
            # we continue iterating while increasing the count
            count = count + 1
        # we compute the request rate
        else:
            last_line=t0

            time_diff = extract_time_diff(first_line,last_line)
            # the request rate metric is time_diff divided by total_no_req
            request_rate[request_index]={count:time_diff.total_seconds()}

            count=0
            request_index = request_index + 1
            first_line=t1
        # change the root line
        t0=t1
    # handle the last transaction
    last_line=t1

    time_diff = extract_time_diff(first_line,last_line)
    request_rate[request_index]={count:time_diff}

    return request_rate




if __name__=="__main__":

    file_path=sys.argv[1]

    delta_time=sys.argv[2]

    address = file_path.split('/')[-1]

    request_rate = compute_request_rate(file_path,delta_time)
    pprint(request_rate)
    # switch on the commands
    # export the computed access patterns
