#!/bin/bash

while read -r line; do
    echo $line | awk '{print $7 $11}'
done <$1
