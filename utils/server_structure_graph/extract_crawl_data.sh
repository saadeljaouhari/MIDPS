#!/bin/sh


interface_name='wlan0'
crawling_agents_ip_regex=$(ifconfig $interface_name  | grep inet6 | awk '{print $2}' | sed -z 's/\n/|/g')

log_file_path='access.log'

rm parsed_site_data

grep -wE "$crawling_agents_ip_regex" $log_file_path | grep -w 200 | grep -w HEAD| awk '{printf "%s %s\n", $7, $11}' |sort | uniq | sed -e 's/ /\n/g' | tr -d '"' > parsed_site_data

python referrer_correlation.py
