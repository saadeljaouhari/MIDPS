#!/bin/sh

verdict_folder_path=$1

for file_name in "$verdict_folder_path"/*; do

	ip_address=$(awk '{print $1}' $file_name)

	# keeping my ip safe:)))
	if [ $ip_address -eq "46.193.1.170" ]
	then
		continue
	fi
	fail2ban-client set aml-jail banip $ip_address

done
