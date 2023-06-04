#!/bin/sh

interface_name=$1

log_file_path=$2

output_location=$3

timestamp=$4

crawling_agents_ip_regex=$(ifconfig $interface_name  | grep inet | awk '{print $2}' | sed -z 's/\n/|/g')

awk -v d1="[$timestamp" '($4) >= d1' $log_file_path | grep -wE "$crawling_agents_ip_regex" | grep -w 200 | grep -w HEAD| awk '{printf "%s %s\n", $7, $11}' | sort | uniq | sed -e 's/ /\n/g' | tr -d '"' > $output_location
