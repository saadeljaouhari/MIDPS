#!/bin/sh

log_file=$1
ip_file='ip_list'

#sort $log_file

while read line; do
    grep -w $line $log_file | sort -t ' ' -k 4.5,4.7M > out/$line
done < $ip_file
