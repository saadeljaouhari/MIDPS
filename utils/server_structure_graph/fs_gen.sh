#!/bin/sh

web_structure_tree_path=utils/server_structure_graph/web_structure_tree


rm $web_structure_tree_path

crawl_start_ts=$1

sh utils/server_structure_graph/extract_crawl_data.sh $crawl_start_ts

python3 utils/server_structure_graph/referrer_correlation.py
