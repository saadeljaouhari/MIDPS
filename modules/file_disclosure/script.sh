#!/bin/sh

while read line; do
	echo $line | awk '{printf("%s %s\n",$7,$11)}' | python3 modules/file_disclosure/check.py
done
