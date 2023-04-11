#!/bin/sh

# Input each line to the modules
while read line; do
	# File disclosure
	echo "$line" | sh ./modules/file_disclosure/script.sh
done
