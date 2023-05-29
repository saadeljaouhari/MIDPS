#!/bin/sh

sleeping_duration=$((5*60))

while true; do
sh utils/crawling_agent/crawling_agent.sh
# trigger the re-computation of the server structure
sh utils/server_structure_graph/fs_gen.sh
sleep $sleeping_duration
done
