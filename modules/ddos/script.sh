#!/bin/sh

tmp_log_path="/tmp/logs"
tmp_ip_path="/tmp/ip_list"
tmp_folder_path="/tmp/out"
# ddos scan logs threshold
threshold=10

while read line; do
	# append the new line to the analysis set
	echo $line >> $tmp_log_path
	line_count=$(wc -l < $tmp_log_path)
	# if the threshold has been reached
	if [ $line_count -eq $threshold ]; then
	#perform previous cleanup if needed
	rm $tmp_ip_path
	rm -rf $tmp_folder_path
	mkdir $tmp_folder_path
	# split the ip's
	awk '{ print $1}' $tmp_log_path | uniq > $tmp_ip_path
	# separate log sequences by ip's
	while read ip_addr; do
    		grep -w $ip_addr $tmp_log_path | sort -t ' ' -k 4.5,4.7M > $tmp_folder_path/$ip_addr
	done < $tmp_ip_path
	# scan the generated data for ddos attacks
	python modules/ddos/script.py
	echo -n > $tmp_log_path
	fi
done
