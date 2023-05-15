#!/bin/sh

root_name=$1

for file in $root_name*; do
	filename=$(basename $file)
	grep -o '\\x[0-9a-f]\{2\}' $file | tr -d '\n' > 'out/'$filename

done
