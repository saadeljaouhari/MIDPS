#!/bin/sh

rm utils/server_structure_graph/web_structure_tree
rm utils/server_structure_graph/parsed_site_data

crawl_start_ts=$1

sh utils/server_structure_graph/extract_crawl_data.sh $crawl_start_ts

python3 utils/server_structure_graph/referrer_correlation.py
