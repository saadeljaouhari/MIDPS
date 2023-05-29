#!/bin/sh

rm utils/server_structure_graph/web_structure_tree
rm utils/server_structure_graph/parsed_site_data

sh utils/server_structure_graph/crawling_agent.sh

python referrer_correlation.py
