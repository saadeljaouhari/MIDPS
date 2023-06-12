#!/bin/sh

# de explicat fiecare parametru ce si cum
old_fs_graph_path="modules/resources/web_structure_tree"
new_fs_graph_path="utils/server_structure_graph/web_structure_tree"

links_file_path="modules/resources/web_pages"
output_links_file_path="modules/resources/web_page_links"

log_file_path='/var/log/nginx/access.log'

sleeping_duration=$((5*60))

while true; do
crawl_start_ts=$(date +"%d/%b/%Y:%H:%M:%S")

sh utils/crawling_agent/crawling_agent.sh $links_file_path
# trigger the re-computation of the server structure
sh utils/server_structure_graph/fs_gen.sh $log_file_path $crawl_start_fs
# check if the fs structure was modified
has_changed=$(diff $old_fs_graph_path $new_fs_graph_path | wc -l )
# If changes occured, update the components
# and recompute the access patterns smartly, by doing a diff
# and the list of links
if [ $has_changed -ne 0 ]; then
mv -f $new_fs_graph_path $old_fs_graph_path

sh utils/gen_resource_links/gen_resource_links.sh $links_file_path $output_links_file_path
fi
sleep $sleeping_duration
done
