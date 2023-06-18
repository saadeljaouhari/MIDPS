#!/bin/sh

source config.conf

file_path=$1
norm_traffic_timeframe_size=$2
#address=$(basename $file_path)

longest_seq_len=$(sh modules/ddos/compute_longest_seq.sh $normal_sequences_path)
python3 modules/ddos/dos_check.py $file_path $norm_traffic_timeframe_size $longest_seq_len $ratio_multiplying_factor
