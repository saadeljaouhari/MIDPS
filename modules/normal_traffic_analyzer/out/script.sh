#!/bin/sh

referrer_path=$1
log_window_path=$2

while IFS= read -r referrer; do
	echo "#####################################################"
	grep -w $referrer $log_window_path | grep -v 301 | awk '{printf "%s %s %s \n",$7,$9,$11}' | sort | uniq
	echo "#####################################################"
done < $referrer_path
