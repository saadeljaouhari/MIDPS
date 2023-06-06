#!/bin/sh

file_path=$1
norm_traffic_timeframe_size=$2
#address=$(basename $file_path)

python3 modules/ddos/dos_check.py $file_path $norm_traffic_timeframe_size
