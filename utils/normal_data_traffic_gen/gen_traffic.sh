#!/bin/sh
links_file_path='utils/normal_data_traffic_gen/web_page_links'

download_path='utils/normal_data_traffic_gen/page_output_tmp'

while true
do
	rm -rf $download_path
	mkdir $download_path
	selected_link=$(shuf -n 1 $links_file_path)
	wget -q -p -P $download_path --inet4-only -e robots=off $selected_link


	sleeping_time=$(shuf -i 5-10 -n 1)
	sleep $((sleeping_time))
done
