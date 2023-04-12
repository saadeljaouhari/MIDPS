from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json

log_file = 'test_logs'
data_dict={}

def correlate(log_file):
#log_format  main  '$remote_addr - $remote_user [$time_local] "$request"
            #'$status $body_bytes_sent "$http_referer" '
            #'"$http_user_agent" "$http_x_forwarded_for"'
    line_no = 0
    f = open(log_file)
    referer = ''
    resource = ''
    for line in f.readlines():
        line = line.rstrip()
        if line_no % 2 == 0:
            resource = line
        if line_no % 2 == 1:
            referer = line

            if referer not in data_dict.keys():
                data_dict[referer]=[resource]
            else:
                if resource not in data_dict[referer]:
                    data_dict[referer].append(resource)

        line_no = line_no + 1

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

    #DotExporter(root).to_picture("udo.png")

def search_key(key):
    pass

#print(json.dumps(data_dict,indent=4))
data_dict = correlate(log_file)
create_tree(data_dict)
