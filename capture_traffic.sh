#!/bin/sh

tmp_log_path="/tmp/logs"
rm $tmp_log_path
# Periodically run the crawling agent
sh ./utils/crawling_agent/run_crawling_agent.sh
# Input each line to the modules
while read line; do
	# File disclosure
	echo "$line" | sh ./modules/file_disclosure/script.sh

	# test
	echo "$line" | sh ./modules/ddos/script.sh
done
