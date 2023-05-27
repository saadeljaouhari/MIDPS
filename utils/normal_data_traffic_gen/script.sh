#!/bin/sh
links_file_path='links'
while true
do
	selected_link=$(shuf -n 1 $links_file_path)
	echo $selected_link
	torify wget -p  "$selected_link"

	sleeping_time=$(shuf -i 60-180 -n 1)
	echo "Crawling over"
	echo Will sleep $sleeping_time
	sleep $((sleeping_time))
done
