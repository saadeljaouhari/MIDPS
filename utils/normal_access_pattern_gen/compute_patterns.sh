#!/bin/sh


extracted_data_path=utils/normal_access_pattern_gen/crawl_logs
mkdir $extracted_data_path

timestamp=$1

mkdir $extracted_data_path/$timestamp

sh utils/server_structure_graph/extract_crawl_data.sh $timestamp $extracted_data_path/$timestamp/normal_access_logs

python3 modules/normal_traffic_analyzer/analyze.py $extracted_data_path/$timestamp
