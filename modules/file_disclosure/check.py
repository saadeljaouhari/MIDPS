import sys
from anytree.search import findall
from anytree.importer import JsonImporter
from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json


def load_tree(file_name):
    f = open(file_name,"r")
    data = f.read()
    importer = JsonImporter()
    tree = importer.import_(data)

    return tree

def check_file_disclosure(line):
# in some cases, especially in malware injection the request length is not standard
    if len(line.split(' ')) == 6:
        resource = line.split(' ')[3]
        referrer = line.split(' ')[5]

        result=findall(tree, filter_=lambda node: node.name == resource)
        if len(result)==0:
            #print('{} attempted a file disclosure. Requested resource: {}'.format(address,resource))
            print("1")
        else:
            print("0")
    else:
            #print('{} attempted a file disclosure. The request has an irregular format'.format(address))
            print("1")

if __name__=="__main__":
    address = sys.argv[1]
    web_structure_file_path = sys.argv[2]
    tree = load_tree(web_structure_file_path)
    for line in sys.stdin:
        check_file_disclosure(line)
