from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json
import re
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

log_file = 'fs_logs'
G = nx.Graph()
data_dict={}
site_root = 'https://blog.pseudot.org'

class LogEntry:
    def __init__(self, ip_address, date_time, request_method, url, http_version, response_code, response_size, referer, user_agent):
        self.ip_address = ip_address
        self.date_time = date_time
        self.request_method = request_method
        self.url = url
        self.http_version = http_version
        self.response_code = response_code
        self.response_size = response_size
        self.referer = referer
        self.user_agent = user_agent


def parse_lines(log_file):
#log_format  main  '$remote_addr - $remote_user [$time_local] "$request"
            #'$status $body_bytes_sent "$http_referer" '
            #'"$http_user_agent" "$http_x_forwarded_for"'
    data_dict={}
    f = open(log_file)
    for log_entry in f.readlines():
        fields = log_entry.split(' ')

        ip_address = fields[0]
        date_time = fields[3] + ' ' + fields[4]
        request_method = fields[5]
        url = fields[6]
        http_version = fields[7]
        response_code = fields[8]
        response_size = fields[9]
        referer = fields[10]
        user_agent = ' '.join(fields[11:])

        log_entry = LogEntry(ip_address, date_time, request_method, url, http_version, response_code, response_size, referer, user_agent)

        log_entry.referer = re.sub('"',"",log_entry.referer)

        if log_entry.referer not in data_dict.keys():
            data_dict[log_entry.referer]=[log_entry.url]
        else:
            if log_entry.url not in data_dict[log_entry.referer]:
                data_dict[log_entry.referer].append(log_entry.url)
    return data_dict

def create_tree(data_dict):
    root = Node("/")

    for key in data_dict.keys():
        #key = key.replace(site_noderoot,"")
        print(key)
        node = Node(key,parent=root)
        for resource in data_dict[key]:
            print(resource)
            leaf = Node(resource,parent=node)

    for pre, fill, node in RenderTree(root):
        print("%s%s" % (pre, node.name))


data_dict = parse_lines(log_file)
#print(json.dumps(data_dict,indent=4))
create_tree(data_dict)

#DotExporter(udo).to_picture("udo.png")
