from anytree.exporter import JsonExporter
from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json

log_file = 'parsed_site_data'
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
        node = Node(key,parent=root)
        for resource in data_dict[key]:
            leaf = Node(resource,parent=node)

    return root


def export_tree(tree,file_name):

    exporter = JsonExporter(indent=4, sort_keys=True)
    json_tree = exporter.export(tree)

    with open(file_name, 'w') as f:
        f.write(json_tree)


#print(json.dumps(data_dict,indent=4))
data_dict = correlate(log_file)
tree = create_tree(data_dict)

DotExporter(tree).to_picture("udo2.png")
export_tree(tree,'web_structure_tree')
