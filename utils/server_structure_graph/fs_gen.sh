#!/bin/sh

# Used in order to extract the ip of the crawling interface
interface_name='enp1s0'
# Output location for the referrer-resource pair needed for the correlation script
output_parsed_site_data='utils/server_structure_graph/parsed_site_data'
output_tree_path='utils/server_structure_graph/web_structure_tree'
# Access log file path
log_file_path=$1
# Extract only the logs after the given timestamp
crawl_start_ts=$2

sh utils/server_structure_graph/extract_crawl_data.sh $interface_name $log_file_path $output_parsed_site_data $crawl_start_ts

python3 utils/server_structure_graph/referrer_correlation.py $output_parsed_site_data $output_tree_path
