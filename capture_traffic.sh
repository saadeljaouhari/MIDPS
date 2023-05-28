#!/bin/sh

tmp_log_path="/tmp/logs"

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

  rm $tmp_log_path

  exit 0
}

trap cleanup INT

# Launch the app agents
launch_agents

# Check for updates in the file structure


# Input each line to the modules
while read line; do
	# File disclosure
	echo "$line" | sh ./modules/file_disclosure/script.sh

	# test
	echo "$line" | sh ./modules/ddos/script.sh
done
