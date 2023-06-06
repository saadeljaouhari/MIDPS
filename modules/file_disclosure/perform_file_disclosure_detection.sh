#!/bin/sh

file_path=$1
address=$(basename $file_path)
while read line; do
	echo $line | awk '{printf("%s %s\n",$3,$5)}' | python3 modules/file_disclosure/check.py $address
done < $file_path
