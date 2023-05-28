#!/bin/sh
links_file_path='links'

while true
do
	selected_link=$(shuf -n 1 $links_file_path)
	wget --inet4-only -q --spider -r -p -nd $selected_link

	sleeping_time=$(shuf -i 5-10 -n 1)
	sleep $((sleeping_time))
done
