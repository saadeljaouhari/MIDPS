#!/bin/sh

#while IFS= read -r line; do
#  echo $line | awk '{printf("%s %s \n",$6,$7)}' | cut -d'"' -f 2 >> filtered_input
#done < out

grep -F '\x' filtered_input >> output_file
