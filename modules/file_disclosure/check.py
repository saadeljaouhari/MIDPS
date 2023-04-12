from anytree.search import findall
from anytree.importer import JsonImporter
from anytree.exporter import DotExporter
from anytree import Node, RenderTree
import json

file_name = "web_structure_tree"

def load_tree(file_name):
    f = open(file_name,"r")
    data = json.load(f)
    importer = JsonImporter()
    tree = importer.import_(data)
    return tree


tree = load_tree(file_name)
#print(RenderTree(tree))
print(findall(tree, filter_=lambda node: node.name == "/posts/botosani/style.css"))
print(findall(tree, filter_=lambda node: node.name == "/posts/bot0sani/style.css"))
