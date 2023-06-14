#!/bin/sh

file_path=$1
address=$(basename $file_path)
while read line; do
	verdict = $(echo $line | python3 modules/file_disclosure/check.py $address)
	echo $verdict
done < $file_path
