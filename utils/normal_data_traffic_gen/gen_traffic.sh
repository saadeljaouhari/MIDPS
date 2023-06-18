#!/bin/sh

source config.conf

links_file_path=$1

sleep_duration=$2

while IFS= read -r link; do
	rm -rf $tmp_download_path
	mkdir $tmp_download_path
	wget -q -p -P $tmp_download_path --inet6-only -e robots=off $link

	sleep $sleep_duration
done < $links_file_path
