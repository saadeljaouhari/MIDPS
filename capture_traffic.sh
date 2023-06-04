#!/bin/sh

tmp_log_path="/tmp/logs"
# divide logs into x seconds windows
log_window_time=10

launch_agents() {
  echo "Launching crawling agents"

  # Run the crawling agent
  sh ./utils/crawling_agent/run_crawling_agent.sh &

  crawling_agent_pid=$!

  # Run the normal traffic generator agent
  #sh ./utils/normal_data_traffic_gen/gen_traffic.sh &

  #traffic_generator_agent_pid=$!

}
initialize_modules(){
  # we generate the links to all the resources for further operations

  web_pages_file_path="utils/gen_resource_links/web_pages"
  output_links_file_path="modules/resources/web_page_links"

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
  sh ./utils/normal_access_pattern_gen/compute_patterns.sh $start_ts

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

log_window_file_path=$tmp_log_path/$window_start_ts
touch $log_window_file_path
#Input each line to the modules
while read line; do
	# File disclosure
	current_timestamp=$(date +%s)
	difference=$((current_timestamp-window_start_ts))

	if [ $difference -ge $log_window_time ]; then
		# saving the last line
		echo $line >> $log_window_file_path

		# launch normal traffic monitor
		#sh ./modules/normal_traffic_analyzer/analyze_traffic.sh $log_window_file_path

		# based on the normal traffic monitor launch the other modules

		# updating the timestamp
		window_start_ts=$current_timestamp

		# Create update the log window file path
		log_window_file_path=$tmp_log_path/$current_timestamp

	else
		echo $line >> $log_window_file_path
	fi

#	echo "$line" | sh ./modules/file_disclosure/script.sh

	# test
#	echo "$line" | sh ./modules/ddos/script.sh
done
