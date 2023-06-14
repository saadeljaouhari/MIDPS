#!/bin/sh

file_path=$1
verdicts_folder_path='/tmp/logs/verdicts'
address=$(basename $file_path)
while read line; do
	verdict=$(echo $line | python3 modules/file_disclosure/check.py $address)
	# if the script detects a file disclosure
	if [ $verdict -eq "1"]
	then
		frame_name=$(basename($dirname $file_path))
		verdict_file_path=$verdicts_folder_path/$frame_name/$address
		echo "$address POSSIBLE FILE DISCLOSURE" > $verdict_file_path
	fi
done < $file_path
