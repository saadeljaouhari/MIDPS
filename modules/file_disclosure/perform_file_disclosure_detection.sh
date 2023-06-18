#!/bin/sh

source config.conf

file_path=$1
address=$(basename $file_path)

while read line; do
	verdict=$(echo $line | python3 modules/file_disclosure/check.py $address $web_structure_graph_file_path )
	# if the script detects a file disclosure
	if [ $verdict -eq "1" ]
	then
		frame_name=$(basename "$(dirname "$file_path")")
		verdict_file_path=$verdicts_folder_path/$frame_name/$address
		# create the frame folder
		mkdir $verdicts_folder_path/$frame_name
		echo "$address POSSIBLE FILE DISCLOSURE" > $verdict_file_path
	fi
done < $file_path
