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
  sh ./utils/normal_data_traffic_gen/gen_traffic.sh &

  traffic_generator_agent_pid=$!

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

# Launch the app agents
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
		sh ./modules/normal_traffic_analyzer/analyze_traffic.sh $log_window_file_path

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
