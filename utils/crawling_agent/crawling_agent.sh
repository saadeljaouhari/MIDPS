#!/bin/sh

web_pages_path="utils/crawling_agent/web_pages"

while IFS= read -r link; do
	wget --inet4-only -q --spider -e robots=off -r -p -nd $link
done < $web_pages_path
