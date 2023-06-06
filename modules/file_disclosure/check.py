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

if __name__=="__main__":
    tree = load_tree(file_name)
    address = sys.argv[1]
    for line in sys.stdin:

        resource = line.split(' ')[0]
        referrer = line.split(' ')[1]

        result=findall(tree, filter_=lambda node: node.name == resource)
        if len(result)==0:
            print('{} attempted a file disclosure. Requested resource: {}'.format(address,resource))
