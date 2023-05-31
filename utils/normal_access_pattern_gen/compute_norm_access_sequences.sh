#!/bin/sh

# referrer path
ref_path_file='utils/normal_access_pattern_gen/referrers'
# extract the referrer field
awk 'NR%2==0' utils/server_structure_graph/parsed_site_data | sort | uniq | tail -n +2 > $ref_path_file
