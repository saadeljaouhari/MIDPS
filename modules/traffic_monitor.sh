#!/bin/sh

while read line; do
	echo $line | sh file_disclosure/script.sh &
	echo $line | sh ddos/script.sh &
done
