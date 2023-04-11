#!/bin/sh

while read line; do
	echo $line | awk '{printf("%s %s",$7,$11)}'
done
