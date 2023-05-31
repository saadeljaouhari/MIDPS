#!/bin/sh

web_pages_path="utils/crawling_agent/web_pages"
sleep_time_between_req=3

while IFS= read -r link; do
	wget --inet4-only -q --spider -e robots=off -r -p -nd $link
	sleep $sleep_time_between_req
done < $web_pages_path
