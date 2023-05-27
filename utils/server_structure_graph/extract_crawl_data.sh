#!/bin/sh

crawling_agent_ip="2a01:cb00:4cc:5800:d7a0:a667:8305:544"

log_file_path='access.log'

rm parsed_site_data

grep -w $crawling_agent_ip $log_file_path | grep -w HEAD | awk '{printf "%s %s\n", $7, $11}' | sort | uniq | sed -e 's/ /\n/g' | tr -d '"' > parsed_site_data

python referrer_correlation.py
