#!/bin/sh

while read line; do
	echo $line | awk '{printf("%s %s\n",$7,$11)}'
done
