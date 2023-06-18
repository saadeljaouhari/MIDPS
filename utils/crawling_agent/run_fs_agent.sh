#!/bin/sh

source config.conf

sleeping_duration=$((5*60))

while true; do
crawl_start_ts=$(date +"%d/%b/%Y:%H:%M:%S")

sh utils/crawling_agent/crawling_agent.sh $links_file_path
# trigger the re-computation of the server structure
sh utils/server_structure_graph/fs_gen.sh $log_file_path $crawl_start_fs
# check if the fs structure was modified
has_changed=$(diff $web_structure_graph_file_path $new_fs_graph_path | wc -l )
# If changes occured, update the components
# and recompute the access patterns smartly, by doing a diff
# and the list of links
if [ $has_changed -ne 0 ]; then
mv -f $new_fs_graph_path $web_structure_graph_file_path

sh utils/gen_resource_links/gen_resource_links.sh $links_file_path $resource_links_file_path
fi
sleep $sleeping_duration
done
