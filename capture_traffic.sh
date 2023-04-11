#!/bin/sh

# Input each line to the modules
while read line; do
	# File disclosure
	sh ./modules/file_disclosure/script.sh "$line"
done
