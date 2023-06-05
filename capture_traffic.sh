#!/bin/sh

tmp_log_path="/tmp/logs"
log_file_path="/var/log/nginx/access.log"
# divide logs into x seconds windows
log_window_time=10
interface_name='enp1s0'

crawling_agent_ip4=$(ifconfig $interface_name  | grep inet | head -n 1 |  awk '{print $2}' )
crawling_agent_ip6=$(ifconfig $interface_name  | grep inet6 | head -n 1 |  awk '{print $2}' )

launch_agents() {
  echo "Launching crawling agents"

  # Run the crawling agent
  sh ./utils/crawling_agent/run_crawling_agent.sh &

  crawling_agent_pid=$!

  # de computat pe fundal access patternurile
  # Run the normal traffic generator agent
  #sh ./utils/normal_data_traffic_gen/gen_traffic.sh &

  #traffic_generator_agent_pid=$!

}
initialize_modules(){
  # we generate the links to all the resources for further operations
  # sa verific daca nu cumva exista deja un access pattern, de la alta operatie

  web_pages_file_path="utils/gen_resource_links/web_pages"
  output_links_file_path="modules/resources/web_page_links"
  normal_sequences_path='modules/resources/normal_access_patterns'

  if [ ! -f $normal_sequences_path ]
  then
  # the page crawling delay
  sleep_time_between_accesses=2

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
  fi

}
cleanup() {
  echo "Cleaning up..."
  if [ -n $crawling_agent_pid ]; then
    kill "$crawling_agent_pid"
  fi
  if [ -n $traffic_generator_agent_pid ]; then
    kill "$traffic_generator_agent_pid"
  fi

  rm -rf $tmp_log_path

  exit 0
}

trap cleanup INT
# initalize the app
echo "Initialising (this may take some time)"
initialize_modules

# Launch the app agents
echo "Launching the app agents"
launch_agents

mkdir $tmp_log_path/

window_start_ts=$(date +%s)
window_start_ts_formatted=$(date +"%d/%b/%Y:%H:%M:%S")

log_window_file_path=$tmp_log_path/$window_start_ts
touch $log_window_file_path

while true
do
	current_timestamp=$(date +%s)
	current_ts_formatted=$(date +"%d/%b/%Y:%H:%M:%S")
	difference=$((current_timestamp-window_start_ts))

	if [ $difference -ge $log_window_time ]; then

	# extract all the logs created after the timestamp
	awk -v d1="[$window_start_ts_formatted" '($4) >= d1' $log_file_path | grep -vE "$crawling_agent_ip4|$crawling_agent_ip6" > $log_window_file_path

	# Launch the traffic monitor
	sh ./modules/normal_traffic_analyzer/analyze_traffic.sh $log_window_file_path

	## update the timestamps
	window_start_ts=$current_timestamp

	window_start_ts_formatted=$current_ts_formatted

	## Create update the log window file path
	log_window_file_path=$tmp_log_path/$current_timestamp
	fi
done
