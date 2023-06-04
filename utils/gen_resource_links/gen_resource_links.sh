#!/bin/sh
links_file_path=$1
output_file_path=$2

while IFS= read -r link; do
	wget --inet4-only --spider -r -nd -e robots=off --follow-tags=a --no-verbose "$link" 2>&1 | grep tmp | awk '{print $3}' | sed -e 's/URL://g' | uniq >> $output_file_path

done < $links_file_path
