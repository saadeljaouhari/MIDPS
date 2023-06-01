#!/bin/sh

# de refactorizat scriptu

crawl_log_timeframe=1


interface_name='enp1s0'
crawling_agents_ip_regex=$(ifconfig $interface_name  | grep inet | awk '{print $2}' | sed -z 's/\n/|/g')

log_file_path='/var/log/nginx/access.log'

extracted_data_path=utils/normal_access_pattern_gen/crawl_logs
rm -rf $extracted_data_path
mkdir $extracted_data_path

timestamp=$1

folder_timestamp=$(date +%s)

mkdir $extracted_data_path/$folder_timestamp

awk -v d1="[$timestamp" '($4) >= d1' $log_file_path | grep -wE "$crawling_agents_ip_regex" | grep -w 200 | grep -w GET | sort | uniq > $extracted_data_path/$folder_timestamp/normal_access_logs

python3 modules/normal_traffic_analyzer/analyze.py $extracted_data_path/$folder_timestamp $crawl_log_timeframe
