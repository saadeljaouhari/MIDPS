#!/bin/sh

sleeping_duration=$((5*60))

while true; do
sh utils/crawling_agent/crawling_agent.sh
sleep $sleeping_duration
done
