#!/bin/sh


web_pages_file_path="utils/gen_resource_links/web_pages"
output_links_file_path="modules/resources/web_page_links"
normal_sequences_path='modules/resources/normal_access_patterns'

# generate the web page resource links
sh utils/gen_resource_links/gen_resource_links.sh $web_pages_file_path $output_links_file_path
# we timestamp the begginning of the operation
# we wait one second of sync reasons
start_ts=$(date +"%d/%b/%Y:%H:%M:%S")
# before starting to analyze traffic we need to crawl the web app at least once
# we check the existence of the file structure tree file
# Run the normal traffic generator agent
sh ./utils/normal_data_traffic_gen/gen_traffic.sh $output_links_file_path $sleep_time_between_accesses
sh ./utils/normal_access_pattern_gen/compute_patterns.sh $crawling_agent_ip6 $start_ts
