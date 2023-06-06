#!/bin/sh

file_path=$1
while read line; do
	echo $line | awk '{printf("%s %s\n",$3,$5)}' | python3 modules/file_disclosure/check.py
done < $file_path
