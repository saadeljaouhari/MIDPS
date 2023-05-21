#!/bin/sh

tmp_log_path="/tmp/logs"
# ddos scan logs threshold
threshold=5

while read line; do
	echo $line >> $tmp_log_path
	line_count=$(wc -l < $tmp_log_path)
	if [[ $line_count -eq $threshold ]]; then
	python modules/ddos/script.py
	echo -n > $tmp_log_path
	fi
done
