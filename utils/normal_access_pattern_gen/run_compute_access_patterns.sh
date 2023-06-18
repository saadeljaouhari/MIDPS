#!/bin/sh

. ./config.conf

new_sequences_file_path='utils/normal_access_pattern_gen/normal_access_patterns'

# the page crawling delay
sleep_time_between_accesses=2

# the ip for the extraction
crawling_agent_ip6=$1

# generate the web page resource links
sh utils/gen_resource_links/gen_resource_links.sh $links_file_path $resource_links_file_path
# we timestamp the begginning of the operation
# we wait one second of sync reasons
start_ts=$(date +"%d/%b/%Y:%H:%M:%S")
# before starting to analyze traffic we need to crawl the web app at least once
# we check the existence of the file structure tree file
# Run the normal traffic generator agent
sh ./utils/normal_data_traffic_gen/gen_traffic.sh $resource_links_file_path $sleep_time_between_accesses
sh ./utils/normal_access_pattern_gen/compute_patterns.sh $crawling_agent_ip6 $start_ts $new_sequences_file_path

# if we re in the initialisation run
if [ ! -f $normal_sequences_path ]
then
	cp -f $new_sequences_file_path $normal_sequences_path
fi
has_changed=$(diff $normal_sequences_path $new_sequences_file_path | wc -l )
# If changes occured, update the components
if [ $has_changed -ne 0 ]; then
mv -f $new_sequences_file_path $normal_sequences_path
fi
