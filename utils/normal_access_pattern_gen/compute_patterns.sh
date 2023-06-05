#!/bin/sh

crawl_log_timeframe=1

analyzing_script_command="export"

log_file_path='/var/log/nginx/access.log'

extracted_data_path=utils/normal_access_pattern_gen/crawl_logs
rm -rf $extracted_data_path
mkdir $extracted_data_path

crawling_agent_ip=$1
timestamp=$2
output_sequences_path=$3

folder_timestamp=$(date +%s)

mkdir $extracted_data_path/$folder_timestamp

awk -v d1="[$timestamp" '($4) >= d1' $log_file_path | grep -wE "$crawling_agent_ip" | grep -w 200 | grep -w GET | sort | uniq > $extracted_data_path/$folder_timestamp/normal_access_logs

python3 modules/normal_traffic_analyzer/analyze.py $analyzing_script_command $extracted_data_path/$folder_timestamp $crawl_log_timeframe $output_sequences_path
