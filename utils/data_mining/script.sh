#!/bin/sh

log_file=$1

while read line; do
	echo $line | awk '{x=sprintf("%s %s %s",$7,$6,$9);print x }' | tr -d '"'
done < $log_file
