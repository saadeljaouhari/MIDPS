#!/bin/sh
user_agent_path='user_agents_list'
links_file_path='links'
count=0
while true
do
	selected_agent=$(shuf -n 1 $user_agent_path)
	selected_link=$(shuf -n 1 $links_file_path)
	echo $selected_link
	torify wget -p  "$selected_link" -U "$selected_agent"

	rc-service tor restart
	sleeping_time=$(shuf -i 15-180 -n 1)
  	((count=count+1))
	echo "Crawling over"
	echo Will sleep $sleeping_time
	echo Pages crawled $count
	sleep $((sleeping_time))
done
