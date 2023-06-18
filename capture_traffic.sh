#!/bin/sh

. ./config.conf

crawling_agent_ip4=$(ifconfig $interface_name  | grep inet | head -n 1 |  awk '{print $2}' )
crawling_agent_ip6=$(ifconfig $interface_name  | grep inet6 | head -n 1 |  awk '{print $2}' )

launch_agents() {
  echo "Launching crawling agents"

  # Run the crawling agent
  sh ./utils/crawling_agent/run_fs_agent.sh &

  crawling_agent_pid=$!

  # Run the normal traffic pattern agent
  sh ./utils/normal_access_pattern_gen/run_pattern_agent.sh $crawling_agent_ip6 &

  traffic_generator_agent_pid=$!

}
initialize_jail_env() {

  # deciding which is goning to be the fail2ban jail file path
  if [ -f "/etc/fail2ban/jail.local" ]
  then
    jail_file_path="/etc/fail2ban/jail.local"
  else
    jail_file_path="/etc/fail2ban/jail.conf"
  fi

    # add jail rule and create fail2ban_logfile
    touch /var/log/fail2ban-aml.log
    touch /etc/fail2ban/filter.d/manban.conf

    jail_exists=$( grep "aml-jail" /etc/fail2ban/jail.conf | wc -l)

    # if the jail doesnt exist
    if [ $jail_exists -eq 0 ]
    then
	    echo -n '
[aml-jail]
enabled = true
#filter
filter=manban
#initial ban time:
bantime = 1m
# incremental banning:
bantime.increment = true
# max banning time = 5 weeks:
bantime.maxtime = 5w
logpath = /var/log/fail2ban-aml.log
' >> $jail_file_path

echo -n '
[Definition]
failregex=
ignoreregex=
' > /etc/fail2ban/filter.d/manban.conf

    # restart the fail2ban service
    systemctl restart fail2ban

    fi
}

initialize_modules(){

  initialize_jail_env

  # if a patternt hasnt been already generated from the previous runs start the process
  if [ ! -f $normal_sequences_path ]
  then
	  sh ./utils/normal_access_pattern_gen/run_compute_access_patterns.sh $crawling_agent_ip6
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
# make the directory for the data frames
data_frames_path=$tmp_log_path/frames
mkdir $data_frames_path
# make the directory for the suspect traffic
mkdir $tmp_log_path/suspect_traffic
# make the directory for the verdicts traffic
mkdir $tmp_log_path/verdicts


window_start_ts=$(date +%s)
window_start_ts_formatted=$(date +"%d/%b/%Y:%H:%M:%S")

log_window_file_path=$data_frames_path/$window_start_ts
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
	log_window_file_path=$data_frames_path/$current_timestamp
	fi
done
