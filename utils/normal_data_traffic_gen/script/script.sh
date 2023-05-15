#!/bin/sh
user_agent_path='user_agents_list'
links_file_path='links'
count=0
selected_agent=$(shuf -n 1 $user_agent_path)
while true
do
	selected_link=$(shuf -n 1 $links_file_path)
	echo $selected_link
	torify wget -p  "$selected_link" -U "$selected_agent"


	restart_tor=$(shuf -i 1-100 -n 1)
	if (( restart_tor<= 50)); then
	rc-service tor restart
	selected_agent=$(shuf -n 1 $user_agent_path)
	fi

	sleeping_time=$(shuf -i 60-180 -n 1)
  	((count=count+1))
	echo "Crawling over"
	echo Will sleep $sleeping_time
	echo Pages crawled $count
	sleep $((sleeping_time))
done
