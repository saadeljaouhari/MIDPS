#!/bin/sh

log_file=$1

log_folder_path=$2

ip_file=$log_folder_path/ip_list

while read line; do
    grep -w $line $log_file | sort -t ' ' -k 4.5,4.7M > $log_folder_path/$line
done < $ip_file
