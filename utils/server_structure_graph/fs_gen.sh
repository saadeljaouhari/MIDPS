#!/bin/sh

source config.conf

# Access log file path
log_file_path=$1
# Extract only the logs after the given timestamp
crawl_start_ts=$2

sh utils/server_structure_graph/extract_crawl_data.sh $interface_name $log_file_path $output_parsed_site_data $crawl_start_ts

python3 utils/server_structure_graph/referrer_correlation.py $output_parsed_site_data $new_fs_graph_path
