#!/bin/sh

. ./config.conf

log_file_path=$1

log_folder_path=$log_file_path-frame

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
python3 modules/normal_traffic_analyzer/analyze.py $script_command $log_folder_path $norm_traffic_timeframe_size $normal_sequences_path
frame_name=$(basename $log_folder_path)
suspect_frame_path=$suspect_traffic_folder_path/$frame_name
# run the other modules if abnormal traffic has been detected
if [ -d $suspect_frame_path ]
then
# We run each module sequentially
for file in "$suspect_frame_path"/*; do
	file_name=$(basename $file)
	sh modules/ddos/perform_dos_detection.sh $file $norm_traffic_timeframe_size
# Before running a module, we check if the previous one has detected anomalies
if [ ! -f $verdicts_folder_path/$frame_name/$file_name ]
then
	sh modules/sqli/perform_sqli_check.sh $file
fi
done

# Before running a module, we check if the previous one has detected anomalies
if [ ! -f $verdicts_folder_path/$frame_name/$file_name ]
then
	sh modules/file_disclosure/perform_file_disclosure_detection.sh $file
fi

# taking action on the verdicts
if [  -d $verdicts_folder_path/$frame_name ]
then
	sh utils/ban_suspicious_activities/apply_ban.sh $verdicts_folder_path/$frame_name
fi

fi
