#!/bin/sh

rm utils/server_structure_graph/web_structure_tree
rm utils/server_structure_graph/parsed_site_data

sh utils/server_structure_graph/extract_crawl_data.sh

python utils/server_structure_graph/referrer_correlation.py
