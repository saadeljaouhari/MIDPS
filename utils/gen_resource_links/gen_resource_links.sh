#!/bin/sh
links_file_path="utils/gen_resource_links/web_pages"
output_file_path="utils/gen_resource_links/web_page_links"

rm $output_file_path
while IFS= read -r link; do
	wget --inet4-only --spider -r -nd -e robots=off --follow-tags=a --no-verbose "$link" 2>&1 | grep tmp | awk '{print $3}' | sed -e 's/URL://g' | uniq >> $output_file_path

done < $links_file_path
