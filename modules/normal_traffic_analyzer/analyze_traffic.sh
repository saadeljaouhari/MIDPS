#!/bin/sh

# de trimis toate post requesturile mai departe

log_file_path=$1

log_folder_path=$log_file_path-frame

norm_traffic_timeframe_size=2

norm_access_pattern_file="modules/resources/normal_access_patterns"

script_command="analyze"

# create the path for the inidividual frame analysis
mkdir $log_folder_path

# separate the ips from the logs
awk '{ print $1 }' $log_file_path | sort | uniq > $log_folder_path/ip_list
# separate the logs by ip
sh modules/normal_traffic_analyzer/separate_logs_by_ip.sh $log_file_path $log_folder_path
# remove the log file
rm $log_file_path
# perform the analysis for each ip access
python3 modules/normal_traffic_analyzer/analyze.py $script_command $log_folder_path $norm_traffic_timeframe_size $norm_access_pattern_file
