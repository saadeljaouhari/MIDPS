#!/bin/sh

file_path=$1
norm_traffic_timeframe_size=$2
normal_seq_file='modules/resources/normal_access_patterns'
ratio_multiplying_factor=5
#address=$(basename $file_path)

longest_seq_len=$(python3 modules/ddos/compute_longest_seq.py $normal_seq_file)
python3 modules/ddos/dos_check.py $file_path $norm_traffic_timeframe_size $longest_seq_len $ratio_multiplying_factor
