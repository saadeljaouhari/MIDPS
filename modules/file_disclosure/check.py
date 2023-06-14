import sys
from anytree.search import findall
from anytree.importer import JsonImporter
from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json

file_name = "modules/resources/web_structure_tree"

def load_tree(file_name):
    f = open(file_name,"r")
    data = f.read()
    importer = JsonImporter()
    tree = importer.import_(data)

    return tree

def check_file_disclosure(line):
# in some cases, especially in malware injection the request length is not standard
    if len(line.split(' ')) != 5:
        resource = line.split(' ')[3]
        referrer = line.split(' ')[5]

        result=findall(tree, filter_=lambda node: node.name == resource)
        if len(result)==0:
            #print('{} attempted a file disclosure. Requested resource: {}'.format(address,resource))
            return True
        else:
            return False
    else:
            #print('{} attempted a file disclosure. The request has an irregular format'.format(address))
            return True

if __name__=="__main__":
    tree = load_tree(file_name)
    address = sys.argv[1]
    for line in sys.stdin:
        check_file_disclosure(line)
