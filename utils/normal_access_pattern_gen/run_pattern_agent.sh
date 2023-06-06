#!/bin/sh

# the ip for the extraction
crawling_agent_ip6=$1

while true
do
sh utils/normal_access_pattern_gen/run_compute_access_patterns.sh $crawling_agent_ip6
done
