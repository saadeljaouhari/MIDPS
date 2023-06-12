#!/bin/bash

filename=$1
max_count=0

while IFS= read -r line
do
    count=$(echo $line | grep -o ','  | wc -l)
    if (( count > max_count )); then
        max_count=$count
    fi
done < $filename

echo $max_count
