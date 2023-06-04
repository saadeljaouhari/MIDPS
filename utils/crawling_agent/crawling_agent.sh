#!/bin/sh

links_file_path=$1

while IFS= read -r link; do
	wget --inet4-only -q --spider -e robots=off -r -p -nd $link
done < $links_file_path
