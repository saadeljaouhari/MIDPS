#!/bin/sh

tmp_log_path="/tmp/logs"
cleanup() {
  echo "Cleaning up..."
  if [ -n $background_pid ]; then
    kill "$background_pid"
  fi

  rm $tmp_log_path

  exit 0
}

trap cleanup INT

# Periodically run the crawling agent
sh ./utils/crawling_agent/run_crawling_agent.sh &

background_pid=$!

# Input each line to the modules
while read line; do
	# File disclosure
	echo "$line" | sh ./modules/file_disclosure/script.sh

	# test
	echo "$line" | sh ./modules/ddos/script.sh
done
