#!/bin/sh

verdict_folder_path=$1

for file_name in "$verdict_folder_path"/*; do

	ip_address=$file_name

	fail2ban-client set aml-jail banip $ip_address

done
