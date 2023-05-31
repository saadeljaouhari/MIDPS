#!/bin/sh

old_fs_graph_path=modules/resources/web_structure_tree
new_fs_graph_path=utils/server_structure_graph/web_structure_tree
#sleeping_duration=$((5*60))

crawl_start_ts=$(date +"%d/%b/%Y:%H:%M:%S")
sh utils/crawling_agent/crawling_agent.sh
# trigger the re-computation of the server structure
sh utils/server_structure_graph/fs_gen.sh $crawl_start_ts
# check if the fs structure was modified
has_changed=$(diff $old_fs_graph_path $new_fs_graph_path | wc -l )
# If changes occured, update the components
if [ $has_changed -ne 0 ]; then
mv -f $new_fs_graph_path $old_fs_graph_path
sh utils/gen_resource_links/gen_resource_links.sh
mv -f utils/gen_resource_links/web_page_links utils/normal_data_traffic_gen
fi
# trigger the re-computation of the access patterns structure
sh utils/normal_access_pattern_gen/compute_norm_access_sequences.sh $crawl_start_ts
# check if the access pattern structure was modified
has_changed=$(diff $old_fs_graph_path $new_fs_graph_path | wc -l )

#sleep $sleeping_duration
