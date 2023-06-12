#!/bin/bash

max_count=0
filename=$1

while IFS= read -r line
do
    count=$(echo $line | grep -o ','  | wc -l)
	echo $count
if [ $count -gt $max_count ]
then
        max_count=$count
fi
done < $filename

echo $max_count
