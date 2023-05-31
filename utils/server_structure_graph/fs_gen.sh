#!/bin/sh

web_structure_tree_path=utils/server_structure_graph/web_structure_tree
extracted_data_path=utils/server_structure_graph/parsed_site_data


rm $web_structure_tree_path
rm $extracted_data_path

crawl_start_ts=$1

echo $extracted_data_path
sh utils/server_structure_graph/extract_crawl_data.sh $crawl_start_ts $extracted_data_path

python3 utils/server_structure_graph/referrer_correlation.py
