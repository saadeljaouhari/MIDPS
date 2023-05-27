#!/bin/sh

sleeping_duration=10

while true; do
sh crawling_agent.sh
sleep $sleeping_duration
done
